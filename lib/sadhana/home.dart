import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:open_file/open_file.dart';
import 'package:sadhana/auth/login.dart';
import 'package:sadhana/background/mbaschedule_check.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/notification/notifcation_setup.dart';
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
import 'package:sadhana/wsmodel/WSAppSetting.dart';
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
  List<Sadhana> tmpSadhanas = new List();
  List<Sadhana> sadhanas = new List();
  double headerWidth = 150.0;
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
  @override
  void initState() {
    super.initState();
    loadSadhana();
    checkSimcityMBA();
    new Future.delayed(Duration.zero, () {
      AppUpdateCheck.startAppUpdateCheckThread(context);
    });
    AppUtils.askForPermission();
    AppSharedPrefUtil.isUserRegistered().then((isUserRegisterd) {
      setState(() {
        this.isUserRegistered = isUserRegisterd;
      });
    });
    subscribeConnnectivityChange();
  }

  void subscribeConnnectivityChange() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(onConnectivityChanged);
  }

  bool isFirst = true;
  void onConnectivityChanged(ConnectivityResult result) async {
    try {
      if (!isFirst) {
        print('on Connectivity change');
        await AppSettingUtil.getServerAppSetting(forceFromServer: true);
        SyncActivityUtils.syncAllUnSyncActivity(context: context);
        if (await AppSharedPrefUtil.isUserRegistered()) {
          MBAScheduleCheck.getMBASchedule();
          AppUpdateCheck.startAppUpdateCheckThread(context);
        }
      }
      isFirst = false;
    } catch (error, s) {
      print(error);
      print(s);
      print("Error while sync all activity:" + error);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void loadSadhana() async {
    await AppSharedPrefUtil.getLastSyncTime();
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
      if (!await AppSharedPrefUtil.isCreatedPreloadedSadhana() &&
          await AppUtils.isInternetConnected()) {
        startLoading();
        Response res = await _api.getSadhanas();
        AppResponse appResponse =
            AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          List<Sadhana> sadhanaList = Sadhana.fromJsonList(appResponse.data);
          print(sadhanaList);
          for (Sadhana sadhana in sadhanaList) {
            await sadhanaDAO.insertOrUpdate(sadhana);
          }
          stopLoading();
          AppSharedPrefUtil.saveCreatedPreloadedSadhana(true);
          if (await AppSharedPrefUtil.isUserRegistered()) {
            askForPreloadActivity(sadhanaList);
          }
        }
        stopLoading();
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
    startLoading();
    try {
      await SyncActivityUtils.loadActivityFromServer(sadhanas,
          context: context);
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopLoading();
  }

  @override
  //Widget build(BuildContext context) {
  Widget pageToDisplay() {
    if (widget.optionsPage == null)
      widget.optionsPage = CommonFunction.appOptionsPage;
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
        title: Text('Sadhana'),
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
        child: Icon(Icons.add),
        onPressed: _onAddSadhanaClick,
        tooltip: 'Add new Sadhana',
      ),
      bottomNavigationBar: CacheData.lastSyncTime != null && isUserRegistered
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text('Last Sadhana Synced on: ' + CacheData.lastSyncTime),
                )
              ],
            )
          : null, // It should null if container then will cover whole page
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
    widgets.add(
        _mainHeaderTitle('<<' + Constant.monthName[today.month - 1] + '>>'));
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
            style: TextStyle(fontWeight: FontWeight.bold),
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
          sadhana: sadhana, daysToDisplay: daysToDisplay);
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
      width: 48,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(weekDay, textScaleFactor: 0.7),
            Text('$date', textScaleFactor: 0.9)
          ],
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
      if (profile != null &&
          AppUtils.equalsIgnoreCase('Simandhar City', profile.center)) {
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
      PopupMenuButton(
        onSelected: (value) {
          handleOptionClick(value);
        },
        tooltip: 'Press to get more options',
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
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
            ),
            PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.settings, color: Colors.blueGrey),
                title: Text('Options    '),
              ),
              value: 'options',
            ),
            /*PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.data_usage, color: Colors.orange),
                title: Text('Attendance App'),
              ),
              value: 'attendance',
            ),*/
          ];
        },
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
        print('On press options');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.optionsPage),
        );
        break;
      case 'attendance':
        Navigator.pushNamed(context, AttendanceHomePage.routeName);
        break;
    }
  }

  Future<File> getGeneratedCSVPath(date) async {
    DateTime selectedMonth = date as DateTime;
    DateTime toDate =
        new DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    return await AppCSVUtils.generateCSVBetween(selectedMonth, toDate);
  }

  void _onScheduleClick() async {
    try {
      /*String filePath = '/storage/emulated/0/Sadhana/June.jpg';
      await openFile(File(filePath));*/
      startLoading();
      File file = await MBAScheduleCheck.getMBASchedule(context: context);
      stopLoading();
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
        startLoading();
        if (await SyncActivityUtils.syncAllUnSyncActivity(
            onBackground: false, context: context, forceSync: true)) {
          CommonFunction.alertDialog(
              context: context,
              msg: "Your sadhana is successfully uploaded to server.");
        }
      } else {
        CommonFunction.alertDialog(
            context: context, msg: "Please connect to internet to sync", type: 'error');
      }
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopLoading();
  }

  void onShareExcel() {
    showMonthPicker(context: context, initialDate: previousMonth)
        .then((date) => shareExcel(date));
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
    showMonthPicker(context: context, initialDate: previousMonth)
        .then((date) => saveExcel(date));
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
