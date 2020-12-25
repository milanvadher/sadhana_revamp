import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/attendance/attendance_constant.dart';
import 'package:sadhana/attendance/attendance_summary.dart';
import 'package:sadhana/attendance/attendance_utils.dart';
import 'package:sadhana/attendance/model/dvd_info.dart';
import 'package:sadhana/attendance/model/event.dart';
import 'package:sadhana/attendance/model/fill_attendance_data.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/attendance/model/session_date.dart';
import 'package:sadhana/attendance/model/user_access.dart';
import 'package:sadhana/attendance/submit_attendance.dart';
import 'package:sadhana/attendance/widgets/date_picker_with_event.dart';
import 'package:sadhana/attendance/widgets/dvd_form.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/remark_picker.dart';
import 'package:sadhana/widgets/title_with_subtitle.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AttendanceHomePage extends StatefulWidget {
  static const String routeName = '/attendance_home';
  final DateTime date;
  final Event event;
  AttendanceHomePage({this.date, this.event});

  @override
  AttendanceHomePageState createState() => AttendanceHomePageState();
}

enum PopUpMenu {
  changeDate,
  attendanceSummary,
  submitAttendance,
}

class AttendanceHomePageState extends BaseState<AttendanceHomePage> {
  bool _selectAll = false;
  ApiService _api = ApiService();
  Event event;
  Session session;
  List<DVDInfo> dvds;
  Hero _dvdFormButton;
  Hero _saveButton;
  UserAccess _userAccess;
  FillAttendanceData fillAttendanceData;
  List<DateTime> _sessionDates = List();
  Map<DateTime, String> sessionNameByDate = Map();
  DateTime selectedDate = CacheData.today;
  final GlobalKey<FormState> _attendanceForm = GlobalKey<FormState>();
  bool isReadOnly = false;
  bool isEditMode = false;
  bool isEventAttendance = false;
  String eventName;
  String eventTitle;

  @override
  void initState() {
    super.initState();
    if (widget.date != null) selectedDate = widget.date;
    if (widget.event != null) {
      isEventAttendance = true;
      event = widget.event;
      isReadOnly = !widget.event.isEditable;
    }
    loadData();
  }

  loadData() async {
    startOverlay();
    await CommonFunction.tryCatchAsync(context, () async {
      _userAccess = CacheData.userAccess;
      if (_userAccess != null && _userAccess.fillAttendanceData != null) {
        fillAttendanceData = _userAccess.fillAttendanceData;
        if (isEventAttendance) {
          eventName = event.name;
        } else {
          eventName = fillAttendanceData.eventName;
          await loadSessionDates();
        }
        await loadEvent(selectedDate);
        await loadDvdData(selectedDate);
        setState(() {
          setReadOnlyField();
        });
      } else {
        CommonFunction.alertDialog(context: context, msg: "You don't have right for Attendance");
      }
    });
    stopOverlay();
  }

  loadEvent(DateTime date) async {
    startOverlay();
    await CommonFunction.tryCatchAsync(context, () async {
      if (fillAttendanceData.isEventType) {
        isEditMode = widget.event.isAttendanceTaken;
      } else {
        if (sessionNameByDate.containsKey(date))
          isEditMode = true;
        else
          isEditMode = false;
      }
      if (isEditMode) {
        event = await getEvent();
      } else {
        String strDate = WSConstant.wsDateFormat.format(date);
        event = await createEvent(eventName, strDate);
      }
      print('event' + event.toString());
      if (event != null) {
        setState(() {
          session = event.sessions.first;
        });
      }
    });
    stopOverlay();
  }

  loadDvdData(DateTime date) async {
    startOverlay();
    String strDate = WSConstant.wsDateFormat.format(date);
    Response res = await _api.getDvdList(strDate, fillAttendanceData.groupName);
    AppResponse appResponse =
        AppResponseParser.parseResponse(res, context: context);
    if (appResponse.isSuccess) {
      print(appResponse.data);
      dvds = DVDInfo.fromJsonList(appResponse.data);
      print(dvds);
    }
    stopOverlay();
  }

  Future<Event> createEvent(String eventName, String strDate) async {
    Response res = await _api.getMBAOfGroup(strDate, fillAttendanceData.groupName);
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.isSuccess) {
      List<Attendance> attendances = Attendance.fromJsonList(appResponse.data);
      if (!isEventAttendance) {
        String sessionType = fillAttendanceData.isGDType ? WSConstant.sessionType_GD : WSConstant.sessionType_General;
        session = Session.fromAttendanceList(fillAttendanceData.groupName, strDate, sessionType, attendances);
        event = Event.fromSession(eventName, session);
      } else {
        event.sessions.first.attendance = attendances;
      }
    }
    return event;
  }

  Future<Event> getEvent() async {
    Response res;
    if (fillAttendanceData.isEventType) {
      res = await _api.getEventAttendance(fillAttendanceData, eventName);
    } else {
      String sessionName = sessionNameByDate[selectedDate];
      res = await _api.getSessionAttendance(sessionName, fillAttendanceData);
    }
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.isSuccess) {
      event = Event.fromJson(appResponse.data);
    }
    return event;
  }

  loadSessionDates() async {
    Response res = await _api.getSessionDates(fillAttendanceData);
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.isSuccess) {
      List<SessionDate> sessionDates = SessionDate.fromJsonList(appResponse.data);
      if (sessionDates != null)
        sessionDates.forEach((str) {
          DateTime dateTime = AppUtils.tryParse(str.date, [WSConstant.DATE_FORMAT], throwErrorIfNotParse: true);
          _sessionDates.add(dateTime);
          sessionNameByDate.putIfAbsent(dateTime, () => str.name);
        });
    }
  }

  onCheck(Attendance attendance) {
    setState(() {
      attendance.isPresent = !attendance.isPresent;
      if (attendance.isPresent) attendance.reason = '';
    });
  }

  @override
  Widget pageToDisplay() {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: fillAttendanceData.isEventType
            ? AppTitleWithSubTitle(
                title: event.eventName,
                subTitle: fillAttendanceData.groupTitle,
              )
            : InkWell(
                onTap: () => _onSelectDate(),
                child: Row(
                  children: <Widget>[
                    AppTitleWithSubTitle(
                      title: new DateFormat('dd MMM yyyy').format(selectedDate),
                      subTitle: fillAttendanceData.groupTitle,
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.date_range),
                  ],
                ),
              ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white30,
              border: Border(
                top: BorderSide(
                  width: 0.0,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                'Select ALL',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Checkbox(
                activeColor: Colors.amber,
                checkColor: Colors.black,
                value: _selectAll,
                onChanged: isReadOnly ? null : _onSelectAll,
              ),
              onTap: isReadOnly
                  ? null
                  : () {
                      _onSelectAll(!_selectAll);
                    },
              selected: true,
            ),
          ),
        ),
        actions: isEventAttendance ? null : _buildAction(),
      ),
      body: SafeArea(
        child: Form(
          key: _attendanceForm,
          child: session != null ? _buildListView() : Container(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: session != null ? _buildFloatingActionButton() : Container(),
    );
  }

  Widget userTile({
    @required Attendance attendance,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(attendance.name),
            trailing: Checkbox(
              activeColor: Colors.red.shade500,
              onChanged: isReadOnly
                  ? null
                  : (val) {
                      onCheck(attendance);
                    },
              value: attendance.isPresent,
            ),
            onTap: isReadOnly
                ? null
                : () {
                    onCheck(attendance);
                  },
          ),
          !attendance.isPresent && (fillAttendanceData.isGDType || fillAttendanceData.isEventType)
              ? Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: TextInputField(
                    valueText: attendance.reason,
                    maxLength: 125,
                    showCounter: false,
                    enabled: !isReadOnly,
                    isRequiredValidation: true,
                    labelText: "Reason for Absent",
                    onSaved: (val) => attendance.reason = val,
                    padding: EdgeInsets.all(0),
                    contentPadding: EdgeInsets.all(13),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildListView() {
    List<Widget> cartList = session.attendance.map((attendance) {
      return Column(
        children: <Widget>[userTile(attendance: attendance), Divider()],
      );
    }).toList();
    cartList.add(Column(children: <Widget>[SizedBox(height: 80)]));
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 12),
        children: [
          Container(
            child: Column(children: cartList),
          )
        ],
      ),
    );
  }

  List<Widget> _buildAction() {
    return <Widget>[
      (!isReadOnly && isEditMode) ? IconButton(icon: Icon(Icons.delete), onPressed: _onDeleteClick) : Container(),
      PopupMenuButton<PopUpMenu>(
        onSelected: !fillAttendanceData.isEventType ? _onPopupSelected : null,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenu>>[
          //const PopupMenuItem<PopUpMenu>(value: PopUpMenu.changeDate, child: Text('Change Date')),
          fillAttendanceData.isCenterType
              ? const PopupMenuItem<PopUpMenu>(value: PopUpMenu.submitAttendance, child: Text('Submit Attendance'))
              : null,
          const PopupMenuItem<PopUpMenu>(value: PopUpMenu.attendanceSummary, child: Text('Attendance Summary')),
        ],
        //icon: Icon(Icons.menu),
      ),
    ];
  }

  Widget _buildFloatingActionButton() {
    return Container(
      height: 60,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton(
            heroTag: _dvdFormButton,
            onPressed: () => _onDVDClick(),
            backgroundColor: Colors.white,
            child: fillAttendanceData.isCenterType
                ? Image.asset('assets/icon/iconfinder_BT_dvd_905549.png',
                    color: Color(0xFFce0e11))
                : Icon(Icons.chat,
                    color: AppUtils.isNullOrEmpty(session.remark)
                        ? Colors.red
                        : Colors.blueAccent),
          ),
          SizedBox(width: 20),
          !isReadOnly
              ? FloatingActionButton.extended(
                  heroTag: _saveButton,
                  onPressed: _onSubmit,
                  //backgroundColor: Colors.white,
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text(isEditMode ? 'Update' : 'Save',
                      style: TextStyle(color: Colors.white)),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> _onSelectDate() async {
    final DateTime picked =
        await showDatePickerWithEvents(context, selectedDate, _sessionDates);
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      if (fillAttendanceData.isGDType) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceHomePage(date: selectedDate),
          ),
        );
      } else {
        setReadOnlyField();
        loadEvent(selectedDate);
        loadDvdData(selectedDate);
      }
    }
  }

  void setReadOnlyField() {
    if (!isEventAttendance) {
      setState(() {
        isReadOnly = isSelectedDateReadOnly();
      });
    }
  }

  bool isSelectedDateReadOnly() {
    return CommonFunction.tryCatchSync(context, () {
      if (fillAttendanceData.isGDType) {
        if (selectedDate.isBefore(CacheData.today
            .add(Duration(days: -_userAccess.attendanceEditableDays))))
          return true;
        else
          return false;
      } else {
        if (isEqualMonth(selectedDate, CacheData.today)) {
          if (isCurrentMonthAttendanceSubmitted())
            return true;
          else
            return false;
        }
        if (CacheData.pendingMonth != null &&
            isGreaterOrEqualMonth(selectedDate, CacheData.pendingMonth))
          return false;
        else {
          if (CacheData.pendingMonth == null) {
            DateTime lastSubmittedMonth = getLastSubmittedMonth();
            if (lastSubmittedMonth == null ||
                isGreaterMonth(selectedDate, lastSubmittedMonth)) return false;
          }
        }
        return true;
      }
    });
  }

  bool isGreaterMonth(DateTime month1, DateTime month2) {
    if (month1.year == month2.year)
      return month1.month > month2.month;
    else if (month1.year > month2.year)
      return true;
    else
      return false;
  }

  bool isGreaterOrEqualMonth(DateTime month1, DateTime month2) {
    if (month1.year == month2.year)
      return month1.month >= month2.month;
    else if (month1.year > month2.year)
      return true;
    else
      return false;
  }

  bool isEqualMonth(DateTime month1, DateTime month2) {
    return (month1.year == month2.year && month1.month >= month2.month);
  }

  DateTime getLastSubmittedMonth() {
    if (_sessionDates != null && _sessionDates.isNotEmpty) {
      _sessionDates.sort((a, b) => b.compareTo(a));
      return _sessionDates.first;
    }
    return null;
  }

  bool isCurrentMonthAttendanceSubmitted() {
    return CacheData.pendingMonth == null && isContainCurrentMonthDates();
  }

  bool isContainCurrentMonthDates() {
    for (DateTime sessionDate in _sessionDates) {
      if (isEqualMonth(sessionDate, CacheData.today)) return true;
    }
    return false;
  }

  void _onPopupSelected(PopUpMenu result) {
    switch (result) {
      case PopUpMenu.changeDate:
        _onSelectDate();
        break;
      case PopUpMenu.attendanceSummary:
        Navigator.pushNamed(context, AttendanceSummaryPage.routeName);
        break;
      case PopUpMenu.submitAttendance:
        onSubmitAttendanceClick();
        break;
      default:
    }
  }

  void onSubmitAttendanceClick() async {
    startOverlay();
    await CommonFunction.tryCatchAsync(context, () async {
      await CacheData.loadPendingMonthForAttendance(
          fillAttendanceData, context);
      if (CacheData.pendingMonth == null) {
        CommonFunction.alertDialog(
            context: context, msg: "You have already submmited Attendance");
      } else {
        goToAttendanceSubmitPage();
      }
    });
    stopOverlay();
  }

  void onAttendanceSubmitted(bool isSubmitted) {
    setState(() {
      setReadOnlyField();
    });
  }

  void _onSelectAll(bool value) {
    _selectAll = value;
    setState(() {
      session.attendance.forEach((res) {
        res.isPresent = _selectAll;
      });
    });
  }

  Future<void> _onDVDClick() async {
    /*Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new DVDForm(session: session);
          },
          fullscreenDialog: true));*/
    if (fillAttendanceData.isCenterType) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Center(child: Text('MBA DVD Details')),
              children: <Widget>[
                Builder(
                  builder: (BuildContext context) => DVDForm(
                    session: session,
                    dvds: dvds,
                    onDVDSubmit: _onDVDEntered,
                    isReadOnly: isReadOnly,
                  ),
                )
              ],
            );
          });
    } else {
      showDialog<String>(
          context: context,
          builder: (_) {
            return RemarkPickerDialog(
              title: Text("Remark"),
              remark: session.remark,
              isEnabled: !isReadOnly,
            );
          }).then(onRemarkEntered);
    }
  }

  onRemarkEntered(String remark) {
    if (!AppUtils.isNullOrEmpty(remark)) {
      setState(() {
        session.remark = remark;
      });
    }
  }

  void _onDVDEntered(DVDInfo dvdInfo) {
    DVDInfo.setSession(session, dvdInfo);
  }

  _onDeleteClick() {
    CommonFunction.alertDialog(
        context: context,
        title: 'Are you sure ?',
        msg:
            "Do you want to delete ${Constant.APP_DATE_FORMAT.format(selectedDate)} Session?",
        showCancelButton: true,
        doneButtonFn: deleteSession);
  }

  deleteSession() async {
    Navigator.pop(context);
    CommonFunction.tryCatchAsync(context, () async {
      Response res = await _api.deleteAttendanceSession(
          session.name, session.dateTime, fillAttendanceData);
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.isSuccess) {
        setState(() {
          _sessionDates.remove(session.dateTime);
          selectedDate = session.dateTime;
        });
        CommonFunction.alertDialog(
            closeable: false,
            context: context,
            msg: "Attendance deleted successfully.",
            doneButtonFn: () {
              Navigator.pop(context);
              if (isEventAttendance) {
                Navigator.pop(context, false);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AttendanceHomePage(date: selectedDate),
                  ),
                );
              }
            });
      }
    });
  }

  void _onSubmit() async {
    print(
        "9999999999999999999999999999999999999SESSIOn DATE =======================================================");
    print(session.date);
    if (CacheData.isAttendanceSubmissionPending() &&
        !isEqualMonth(CacheData.pendingMonth, selectedDate)) {
      String strMonth = DateFormat.yMMM().format(CacheData.pendingMonth);
      CommonFunction.alertDialog(
          context: context,
          msg:
              "$strMonth month's attendance submission is pending, Please submit Attendance to continue.",
          doneButtonFn: () {
            Navigator.pop(context);
            goToAttendanceSubmitPage();
          });
      return;
    }
    startOverlay();
    await CommonFunction.tryCatchAsync(context, () async {
      if (_attendanceForm.currentState.validate()) {
        _attendanceForm.currentState.save();
        if (_validateDVD() && _validateAttendance()) {
          print(event);
          Response res = await _api.submitAttendanceSession(event);
          AppResponse appResponse =
              AppResponseParser.parseResponse(res, context: context);
          if (appResponse.isSuccess) {
            if (!fillAttendanceData.isEventType) {
              setState(() {
                _sessionDates.add(session.dateTime);
                String sessionName =
                    AttendanceUtils.getSessionName(appResponse.data);
                if (sessionName != null) {
                  sessionNameByDate.putIfAbsent(
                      session.dateTime, () => sessionName);
                  session.name = sessionName;
                }
              });
            }
            setState(() {
              isEditMode = true;
            });
            if (CacheData.pendingMonth == null)
              CacheData.pendingMonth = session.dateTime;
            CommonFunction.alertDialog(
                closeable: false,
                context: context,
                msg: "Attendance submitted successfully.",
                doneButtonFn: () {
                  Navigator.pop(context);
                  if (isEventAttendance) Navigator.pop(context, true);
                  //Navigator.pop(context);
                });
          }
        }
      }
    });
    stopOverlay();
  }

  void goToAttendanceSubmitPage() {
    if (CacheData.pendingMonth != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubmitAttendancePage(
            CacheData.pendingMonth,
            onAttendanceSubmit: onAttendanceSubmitted,
          ),
        ),
      );
    }
  }

  bool _validateDVD() {
    if (fillAttendanceData.isCenterType) {
      if (session.dvdNo == null && session.remark == null) {
        CommonFunction.alertDialog(
            context: context, msg: "Please fill DVD Details", type: 'error');
        return false;
      }
    }
    return true;
  }

  bool _validateAttendance() {
    bool isAnyPresent = false;
    for (Attendance attendance in session.attendance) {
      if (attendance.isPresent) {
        isAnyPresent = true;
        break;
      }
    }
    if (!isAnyPresent) {
      CommonFunction.alertDialog(
          context: context, msg: "One Person should be present", type: 'error');
      return false;
    }
    return true;
  }
}
