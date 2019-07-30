import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/attendance/attendance_constant.dart';
import 'package:sadhana/attendance/attendance_summary.dart';
import 'package:sadhana/attendance/model/dvd_info.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/attendance/submit_attendance.dart';
import 'package:sadhana/attendance/widgets/date_picker_with_event.dart';
import 'package:sadhana/attendance/widgets/dvd_form.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/title_with_subtitle.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AttendanceHomePage extends StatefulWidget {
  static const String routeName = '/attendance_home';
  final DateTime date;

  AttendanceHomePage({this.date});

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
  Session session;
  Hero _dvdFormButton;
  Hero _saveButton;
  UserRole _userRole;
  List<DateTime> _sessionDates = List();
  DateTime selectedDate = CacheData.today;
  bool isSimcityGroup = false;
  final GlobalKey<FormState> _attendanceForm = GlobalKey<FormState>();
  bool isReadOnly = false;

  @override
  void initState() {
    super.initState();
    if (widget.date != null) selectedDate = widget.date;
    loadData();
  }

  loadData() async {
    startOverlay();
    try {
      _userRole = CacheData.userRole;
      if (_userRole != null && _userRole.isAttendanceCord) {
        isSimcityGroup = _userRole.isSimCityGroup;
        await loadSessionDates();
        await loadSession(selectedDate);
        setState(() {
          checkForReadOnly();
        });
      } else {
        CommonFunction.alertDialog(context: context, msg: "You don't have right for Attendance");
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopOverlay();
  }

  loadSession(DateTime date) async {
    startOverlay();
    try {
      String strDate = WSConstant.wsDateFormat.format(date);
      if (_sessionDates.contains(date)) {
        Response res = await _api.getAttendanceSession(strDate, _userRole.groupName);
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          setState(() {
            session = Session.fromJson(appResponse.data);
          });
          print(session);
        }
      } else {
        Response res = await _api.getMBAOfGroup(strDate, _userRole.groupName);
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          List<Attendance> attendances = Attendance.fromJsonList(appResponse.data);
          String sessionType = isSimcityGroup ? WSConstant.sessionType_GD : WSConstant.sessionType_General;
          setState(() {
            session = Session.fromAttendanceList(_userRole.groupName, strDate, sessionType, attendances);
            print('blank session' + session.toString());
          });
        }
      }
    } catch (e, s) {
      print(s);
    }
    stopOverlay();
  }

  loadSessionDates() async {
    Response res = await _api.getSessionDates(_userRole.groupName);
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.status == WSConstant.SUCCESS_CODE) {
      List<String> strDates = (appResponse.data as List)?.map((e) => e.toString())?.toList();
      if (strDates != null)
        strDates.forEach((str) => _sessionDates.add(AppUtils.tryParse(str, [WSConstant.DATE_FORMAT], throwErrorIfNotParse: true)));
    }
  }

  onCheck(Attendance attendance) {
    setState(() {
      attendance.isPresent = !attendance.isPresent;
    });
  }

  @override
  Widget pageToDisplay() {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: InkWell(
          onTap: () => _selectDate(),
          child: Row(
            children: <Widget>[
              AppTitleWithSubTitle(
                title: new DateFormat('dd MMM yyyy').format(selectedDate),
                subTitle: _userRole.groupTitle,
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.date_range),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: Colors.blueGrey,
            child: Card(
              elevation: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 6, left: 20, bottom: 6),
                    child: Text('Select All'),
                  ),
                  Checkbox(value: _selectAll, onChanged: isReadOnly ? null : _onSelectAll),
                ],
              ),
            ),
          ),
        ),
        actions: _buildAction(),
      ),
      body: SafeArea(
          child: Form(
        key: _attendanceForm,
        child: session != null ? _buildListView() : Container(),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildCardView(Attendance attendance) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              ListTile(
                dense: true,
                title: Text(attendance.name),
                onTap: isReadOnly
                    ? null
                    : () {
                        onCheck(attendance);
                      },
                trailing: Checkbox(
                  onChanged: isReadOnly
                      ? null
                      : (val) {
                          onCheck(attendance);
                        },
                  value: attendance.isPresent,
                ),
              ),
              !attendance.isPresent && isSimcityGroup
                  ? Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: TextInputField(
                        valueText: attendance.reason,
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
          )),
    );
  }

  Widget _buildListView() {
    //List<Widget> cartList = session.attendance.map((attendance) => _buildCardView(attendance)).toList();
    //cartList.add(SizedBox(height: 70));
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListView(children: [
        Container(
          child: Column(
            children: session.attendance.map((attendance) => _buildCardView(attendance)).toList(),
          ),
        )
      ]),
    );
  }

  List<Widget> _buildAction() {
    return <Widget>[
      PopupMenuButton<PopUpMenu>(
        onSelected: _onPopupSelected,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenu>>[
              //const PopupMenuItem<PopUpMenu>(value: PopUpMenu.changeDate, child: Text('Change Date')),
              !isSimcityGroup
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
      height: 70,
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(80),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !isSimcityGroup
              ? FloatingActionButton(
                  heroTag: _dvdFormButton,
                  onPressed: () => _onDVDClick(),
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/icon/iconfinder_BT_dvd_905549.png', color: Colors.red),
                )
              : Container(),
          !isSimcityGroup ? SizedBox(width: 20) : Container(),
          !isReadOnly
              ? FloatingActionButton.extended(
                  heroTag: _saveButton,
                  onPressed: _onSubmit,
                  //backgroundColor: Colors.white,
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text('Save', style: TextStyle(color: Colors.white)),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePickerWithEvents(context, selectedDate, _sessionDates);
    if (picked != null) {
      selectedDate = picked;
      if (isSimcityGroup) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceHomePage(date: selectedDate),
          ),
        );
      } else {
        checkForReadOnly();
        loadSession(selectedDate);
      }
    }
  }

  void checkForReadOnly() {
    if (_userRole.isSimCityGroup) {
      if (selectedDate.isBefore(CacheData.today.add(Duration(days: -AttendanceConstant.SIMCITY_MAX_ALLOWED))))
        isReadOnly = true;
      else
        isReadOnly = false;
    } else {
      if (selectedDate.month == CacheData.today.month) {
        if (isCurrentMonthAttendanceSubmitted())
          isReadOnly = true;
        else
          isReadOnly = false;
      } else {
        if (CacheData.pendingMonth != null && selectedDate.month == CacheData.pendingMonth.month)
          isReadOnly = false;
        else
          isReadOnly = true;
      }
    }
    //Temp
    //if (_sessionDates.contains(selectedDate)) isReadOnly = true;
  }

  bool isCurrentMonthAttendanceSubmitted() {
    return CacheData.pendingMonth == null && isContainCurrentMonthDates();
  }

  bool isContainCurrentMonthDates() {
    for (DateTime sessionDate in _sessionDates) {
      if (sessionDate.month == CacheData.today.month) return true;
    }
    return false;
  }

  void _onPopupSelected(PopUpMenu result) {
    switch (result) {
      case PopUpMenu.changeDate:
        _selectDate();
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
    try {
      await CacheData.loadPendingMonthForAttendance(_userRole.groupName, context);
      if (CacheData.pendingMonth == null) {
        CommonFunction.alertDialog(context: context, msg: "You have already submmited Attendance");
      } else {
        goToAttendanceSubmitPage();
      }
    } catch (e, s) {
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopOverlay();
  }

  void onAttendanceSubmitted(bool isSubmitted) {
    setState(() {
      checkForReadOnly();
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
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Center(
              child: Text('MBA DVD Details'),
            ),
            children: <Widget>[
              Builder(
                builder: (BuildContext context) => DVDForm(
                      session: session,
                      onDVDSubmit: _onDVDEntered,
                      isReadOnly: isReadOnly,
                    ),
              )
            ],
          );
        });
  }

  void _onDVDEntered(DVDInfo dvdInfo) {
    DVDInfo.setSession(session, dvdInfo);
  }

  void _onSubmit() async {
    if (CacheData.isAttendanceSubmissionPending()) {
      String strMonth = DateFormat.yMMM().format(CacheData.pendingMonth);
      CommonFunction.alertDialog(
          context: context,
          msg: "$strMonth month's attendance submission is pending, Please submit Attendance to continue.",
          doneButtonFn: () {
            Navigator.pop(context);
            goToAttendanceSubmitPage();
          });
      return;
    }
    startOverlay();
    try {
      if (_attendanceForm.currentState.validate()) {
        _attendanceForm.currentState.save();
        if (_validateDVD() && _validateAttendance()) {
          print(session);
          Response res = await _api.submitAttendanceSession(session);
          AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
          if (appResponse.status == WSConstant.SUCCESS_CODE) {
            _sessionDates.add(session.dateTime);
            CommonFunction.alertDialog(
                closeable: false,
                context: context,
                msg: "Attendance submitted successfully.",
                doneButtonFn: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
          }
        }
      }
    } catch (e, s) {
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
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
    if (!isSimcityGroup) {
      if (session.dvdNo == null && session.dvdPart == null && session.remark == null) {
        CommonFunction.alertDialog(context: context, msg: "Please fill DVD Details", type: 'error');
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
      CommonFunction.alertDialog(context: context, msg: "One Person should be present", type: 'error');
      return false;
    }
    return true;
  }
}
