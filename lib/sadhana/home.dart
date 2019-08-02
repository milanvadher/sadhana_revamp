import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:open_file/open_file.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/background/mbaschedule_check.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appcsvutils.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'package:sadhana/widgets/appupdatecheck.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/create_sadhana_dialog.dart';
import 'package:sadhana/widgets/nameheading.dart';
import 'package:sadhana/widgets/sadhana_horizontal_panel.dart';
import 'package:sadhana/wsmodel/appresponse.dart';
import 'package:share_extend/share_extend.dart';

import '../attendance/attendance_home.dart';
//import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  HomePage({
    Key key,
    this.optionsPage,
  }) : super(key: key);

  Widget optionsPage;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseState<HomePage> {
  static DateTime now = new DateTime.now();
  DateTime today = new DateTime(now.year, now.month, now.day);
  DateTime previousMonth = DateTime(now.year, now.month - 1);
  static int durationInDays = Constant.displayDays;
  List<Sadhana> sadhanas = new List();
  double headerWidth = 130.0;
  double buttonWidth = 45;
  Brightness theme;
  BuildContext context;
  bool isSimcityMBA = false;
  double mobileWidth;
  SadhanaDAO sadhanaDAO = SadhanaDAO();
  ActivityDAO activityDAO = ActivityDAO();
  ApiService _api = ApiService();
  int sadhanaIndex = 0;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isUserRegistered = false;
  bool showOptionMenu = false;
  bool isAttendanceCord = false;
  UserRole role;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    loadSadhana();
    checkSimcityMBA();
    new Future.delayed(Duration.zero, () {
      OnAppOpenBackgroundThread.startBackgroundThread(context);
    });
    AppUtils.askForPermission();
    AppSharedPrefUtil.isUserRegistered().then((isUserRegistered) {
      setState(() {
        this.isUserRegistered = isUserRegistered;
      });
    });
    loadUserRole();
    /*AppSettingUtil.getServerAppSetting().then((appSetting) {
      setState(() {
        showCSVOption = appSetting.showCSVOption;
      });
    });*/
    subscribeConnectivityChange();
  }

  loadUserRole() async {
    await loadUserRoleFromServer();
    await loadUserRoleFromSharedPref();
  }

  loadUserRoleFromSharedPref() async {
    role = await AppSharedPrefUtil.getUserRole();
    if (role != null) {
      if (role.isAttendanceCord) {
        setState(() {
          showOptionMenu = true;
          isAttendanceCord = true;
        });
      } else {
        setState(() {
          showOptionMenu = false;
          isAttendanceCord = false;
        });
      }
    }
  }

  loadUserRoleFromServer() async {
    if (await AppUtils.isInternetConnected()) {
      await CacheData.loadUserRole(context);
    }
  }

  void subscribeConnectivityChange() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(onConnectivityChanged);
  }

  bool isFirst = true;

  void onConnectivityChanged(ConnectivityResult result) async {
    try {
      if (!isFirst) {
        print('on Connectivity change');
        if (await AppUtils.isInternetConnected()) {
          await AppSettingUtil.getServerAppSetting(forceFromServer: true);
          OnAppOpenBackgroundThread.startBackgroundThread(context);
          AppUtils.updateInternetDate();
          if (await AppSharedPrefUtil.isUserRegistered()) {
            SyncActivityUtils.syncAllUnSyncActivity(context: context);
            MBAScheduleCheck.getMBASchedule();
          }
        }
      }
      isFirst = false;
    } catch (error, s) {
      print("Error while sync all activity:" + error);
      print(s);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void loadSadhana() async {
    await AppSharedPrefUtil.getStrLastSyncTime();
    await createPreloadedSadhana();
    await sadhanaDAO.getAll();
    setState(() {
      sadhanas = CacheData.getSadhanas();
    });
    SyncActivityUtils.syncAllUnSyncActivity(context: context);
  }

  void addNewSadhana(Sadhana sadhana) {
    sadhanas.add(sadhana);
  }

  Future<void> createPreloadedSadhana() async {
    try {
      if (!await AppSharedPrefUtil.isCreatedPreloadedSadhana() && await AppUtils.isInternetConnected()) {
        startOverlay();
        Response res = await _api.getSadhanas();
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          List<Sadhana> sadhanaList = Sadhana.fromJsonList(appResponse.data);
          print(sadhanaList);
          for (Sadhana sadhana in sadhanaList) {
            await sadhanaDAO.insertOrUpdate(sadhana);
          }
          stopOverlay();
          AppSharedPrefUtil.saveCreatedPreloadedSadhana(true);
          if (await AppSharedPrefUtil.isUserRegistered()) {
            askForPreloadActivity(sadhanaList);
          }
        }
        stopOverlay();
      }
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  /*void checkForForceSync() async {
      bool check = DateTime.now().isBefore(DateTime(2019,8,15));
      if(check && await AppSharedPrefUtil.isForceSyncRemained() && await AppUtils.isInternetConnected()) {
        AppSetting serverAppSetting = await AppSettingUtil.getServerAppSetting(forceFromServer: true);
        if(serverAppSetting.forceSync) {
          askForPreloadActivity(sadhanas);
        }
      }
  }*/

  void askForPreloadActivity(List<Sadhana> sadhanaList) {
    CommonFunction.alertDialog(
      closeable: false,
      context: context,
      title: 'Load Data',
      msg: "Do you want to load sadhana data from server?",
      doneButtonText: 'Yes',
      cancelButtonText: 'No',
      doneButtonFn: () {
        Navigator.pop(context);
        CommonFunction.alertDialog(
            context: context,
            title: '',
            msg: "It may take several minutes, Pls wait till it completes.",
            closeable: false,
            doneButtonText: 'OK',
            type: 'info',
            doneButtonFn: () {
              Navigator.pop(context);
              loadPreloadedActivity(sadhanaList);
            });
      },
      showCancelButton: true,
    );
  }

  void loadPreloadedActivity(List<Sadhana> sadhanas) async {
    startOverlay();
    try {
      await SyncActivityUtils.loadActivityFromServer(sadhanas, context: context);
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopOverlay();
  }

  @override
  //Widget build(BuildContext context) {
  Widget pageToDisplay() {
    if (widget.optionsPage == null) widget.optionsPage = CommonFunction.appOptionsPage;
    sadhanas = CacheData.getSadhanas();
    theme = Theme.of(context).brightness;
    this.context = context;
    mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset('images/logo_dada.png'),
        ),
        title: Text('SadhanaQA'),
        actions: _buildActions(),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: headerWidth,
                  child: Column(
                    children: _buildLeftPanel(),
                  ),
                ),

                Container(
                  width: mobileWidth - headerWidth,
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Column(children: _buildRightPanelWidget()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: _onAddSadhanaClick,
        tooltip: 'Add new Sadhana',
      ),
      bottomNavigationBar: CacheData.lastSyncTime != null && isUserRegistered
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildSyncStatus(),
                SizedBox(
                  height: 5,
                )
              ],
            )
          : null, // It should null if container then will cover whole page
    );
  }

  Widget _buildSyncStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.sync, size: 14),
        SizedBox(width: 5),
        Container(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14.0, color: theme == Brightness.dark ? Colors.white : Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'Last Sadhana Synced on: '),
                TextSpan(text: '${CacheData.lastSyncTime}', style: new TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _onAddSadhanaClick() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateSadhanaDialog(onDone: addNewSadhana),
        fullscreenDialog: true,
      ),
    );
    /*showDialog(context: context, builder: (_) => CreateSadhanaDialog(onDone: addNewSadhana)).then((value) {
      setState(() {});
    });*/
  }

  List<Widget> _buildLeftPanel() {
    List<Widget> widgets = new List();
    widgets.add(_mainHeaderTitle(DateFormat.MMMM().format(today)));
    List<Widget> sadhanaHeadings = sadhanas.map((sadhana) {
      return NameHeading(headerWidth: headerWidth, sadhana: sadhana);
    }).toList();
    widgets.addAll(sadhanaHeadings);
    return widgets;
  }

  Widget _mainHeaderTitle(title) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        height: 60,
        width: headerWidth + 10,
        child: Center(
          child: Text(
            title,
            overflow: TextOverflow.fade,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRightPanelWidget() {
    List<DateTime> daysToDisplay = getDaysToDisplay();
    List<Widget> rightWidgets = new List();
    rightWidgets.add(_headerList(daysToDisplay));
    List<Widget> activityWidgets = sadhanas.map((sadhana) {
      return SadhanaHorizontalPanel(
        sadhana: sadhana,
        daysToDisplay: daysToDisplay,
        buttonWidth: buttonWidth,
      );
    }).toList();
    rightWidgets.addAll(activityWidgets);
    return rightWidgets;
  }

  getDaysToDisplay() {
    return List.generate(durationInDays, (int index) {
      return today.subtract(new Duration(days: index));
    });
  }

  Widget _headerListData(String weekDay, int date) {
    return Container(
      height: 60,
      width: buttonWidth,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(weekDay, textScaleFactor: 0.7), Text('$date', textScaleFactor: 0.9)],
        ),
      ),
    );
  }

  Widget _headerList(List<DateTime> daysToDisplay) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(0, 0, 5, 4),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: daysToDisplay.map((day) {
            return _headerListData(Constant.weekName[day.weekday - 1], day.day);
          }).toList(),
        ),
      ),
    );
  }

  void checkSimcityMBA() async {
    if (await AppSharedPrefUtil.isUserRegistered()) {
      Profile profile = await CacheData.getUserProfile();
      if (profile != null && AppUtils.equalsIgnoreCase(WSConstant.center_Simcity, profile.center)) {
        setState(() {
          isSimcityMBA = true;
        });
      }
    }
  }

  List<Widget> _buildActions() {
    return <Widget>[
      isSimcityMBA
          ? IconButton(
              icon: Image.asset('assets/icon/calendar-icon.png'),
              onPressed: _onScheduleClick,
              tooltip: 'MBA Schedule',
            )
          : Container(),
      isUserRegistered
          ? IconButton(
              icon: Icon(Icons.backup),
              onPressed: _onSyncClicked,
              tooltip: 'Sync Data',
            )
          : Container(),
      showOptionMenu
          ? PopupMenuButton(
              onSelected: (value) {
                handleOptionClick(value);
              },
              tooltip: 'Press to get more options',
              itemBuilder: (BuildContext context) {
                return [
                  /*PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.save_alt, color: Colors.red),
                title: Text('Save CSV'),
              ),
              value: 'save_excel',
            ),
            PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.share, color: Colors.green),
                title: Text('Share CSV     '),
              ),
              value: 'share_excel',
            ),*/
                  PopupMenuItem(
                    child: ListTile(
                      trailing: Icon(Icons.settings, color: Colors.blueGrey),
                      title: Text('Options    '),
                    ),
                    value: 'options',
                  ),
                  isAttendanceCord
                      ? PopupMenuItem(
                          child: ListTile(
                            trailing: Icon(Icons.assignment_turned_in, color: Colors.blueGrey),
                            title: Text('Attendance'),
                          ),
                          value: 'attendance',
                        )
                      : null,
                ];
              },
            )
          : IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => widget.optionsPage),
                );
              },
              tooltip: 'Options',
            )
    ];
  }

  void handleOptionClick(String value) {
    print(value);
    switch (value) {
      case 'save_excel':
        onSaveExcel();
        break;
      case 'share_excel':
        //Navigator.pushNamed(context, TimeTablePage.routeName);
        onShareExcel();
        break;
      case 'options':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.optionsPage),
        );
        break;
      case 'order_change':
        showChangeOrderDialog();
        break;
      case 'attendance':
        onAttendanceClick();
        break;
    }
  }

  showChangeOrderDialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(children: <Widget>[
            Builder(
              builder: (BuildContext context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text("City"),
                        onTap: () => {},
                      );
                    },
                  ),
                )
              ]
          ),
            )
          ]);
        });
  }

  void onAttendanceClick() async {
    startOverlay();
    if (await AppUtils.isInternetConnected()) {
      await CacheData.loadAttendanceData(context);
      if (CacheData.userRole != null) {
        loadUserRoleFromSharedPref();
        if (isAttendanceCord) {
          if (CacheData.isAttendanceSubmissionPending()) {
            String strMonth = DateFormat.yMMM().format(CacheData.pendingMonth);
            CommonFunction.alertDialog(
                context: context,
                msg: "$strMonth month's attendance submission is pending, Please submit Attendance.",
                doneButtonFn: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AttendanceHomePage.routeName);
                });
          } else {
            Navigator.pushNamed(context, AttendanceHomePage.routeName);
          }
          stopOverlay();
        }
      } else
        print("User role is null");
    } else {
      CommonFunction.displayInternetNotAvailableDialog(context: context);
    }
    stopOverlay();
  }

  Future<File> getGeneratedCSVPath(date) async {
    DateTime selectedMonth = date as DateTime;
    DateTime toDate = new DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    return await AppCSVUtils.generateCSVBetween(selectedMonth, toDate);
  }

  void _onScheduleClick() async {
    try {
      /*String filePath = '/storage/emulated/0/Sadhana/June.jpg';
      await openFile(File(filePath));*/
      startOverlay();
      File file = await MBAScheduleCheck.getMBASchedule(context: context);
      stopOverlay();
      if (file != null) {
        OpenFile.open(file.path);
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  void _onSyncClicked() async {
    //Navigator.pushNamed(context, RegistrationPage.routeName);
    try {
      if (await AppUtils.isInternetConnected()) {
        startOverlay();
        if (await SyncActivityUtils.syncAllUnSyncActivity(onBackground: false, context: context, forceSync: true)) {
          CommonFunction.alertDialog(context: context, msg: "Your sadhana is successfully uploaded to server.");
        }
      } else {
        CommonFunction.displayInternetNotAvailableDialog(context: context);
      }
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopOverlay();
  }

  void onShareExcel() {
    showMonthPicker(context: context, initialDate: previousMonth).then((date) => shareExcel(date));
  }

  shareExcel(date) async {
    if (date != null) {
      File file = await getGeneratedCSVPath(date);
      if (file != null) {
        await ShareExtend.share(file.path, "file");
      }
    }
  }

  void onSaveExcel() {
    showMonthPicker(context: context, initialDate: previousMonth).then((date) => saveExcel(date));
  }

  saveExcel(date) async {
    if (date != null) {
      File file = await getGeneratedCSVPath(date);
      if (file != null) {
        CommonFunction.alertDialog(
            context: context,
            msg: 'Your File is successuflly created, Path: ${file.path}',
            doneButtonFn: () {
              Navigator.pop(context);
              OpenFile.open(file.path);
            });
      }
    }
  }

/*
List<Sadhana> tmpSadhanas = new List();
  void addSadhana({
    @required int id,
    @required SadhanaType type,
    @required String title,
    @required List<Color> color,
  }) {
    tmpSadhanas.add(Sadhana(
        sadhanaName: title,
        description: "Have you completed sadhana?",
        lColor: color[0],
        dColor: color[1],
        isPreloaded: true,
        type: type,
        index: sadhanaIndex++));
  }
  void loadPreloadedSadhana() {
    addSadhana(
      id: 1,
      type: SadhanaType.BOOLEAN,
      title: 'Samayik',
      color: Constant.colors[0],
    );
    addSadhana(id: 2, type: SadhanaType.NUMBER, title: 'Vanchan', color: Constant.colors[3]);
    addSadhana(id: 3, type: SadhanaType.BOOLEAN, title: 'Vidhi', color: Constant.colors[7]);
    addSadhana(id: 4, type: SadhanaType.BOOLEAN, title: 'G. Satsang', color: Constant.colors[8]);
    addSadhana(id: 5, type: SadhanaType.NUMBER, title: 'Seva', color: Constant.colors[12]);
  }*/
}
