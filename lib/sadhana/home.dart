import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sadhana/auth/registration/registration.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appcsvutils.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/create_sadhana_dialog.dart';
import 'package:sadhana/widgets/nameheading.dart';
import 'package:sadhana/widgets/sadhana_horizontal_panel.dart';
import 'package:sadhana/wsmodel/appresponse.dart';
import 'package:sadhana/wsmodel/ws_sadhana_activity.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

import '../attendance/attendance_home.dart';
//import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({
    Key key,
    this.optionsPage,
  }) : super(key: key);

  final Widget optionsPage;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseState<HomePage> {
  static DateTime now = new DateTime.now();
  DateTime today = new DateTime(now.year, now.month, now.day);
  static int durationInDays = Constant.displayDays;
  List<Sadhana> tmpSadhanas = new List();
  List<Sadhana> sadhanas = new List();
  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime.now();
  double headerWidth = 150.0;
  Brightness theme;
  BuildContext context;
  double mobileWidth;
  SadhanaDAO sadhanaDAO = SadhanaDAO();
  ActivityDAO activityDAO = ActivityDAO();
  ApiService _api = ApiService();
  int sadhanaIndex = 0;

  @override
  void initState() {
    super.initState();
    loadSadhana();
  }

  void loadSadhana() async {
    await AppSharedPrefUtil.getLastSyncTime();
    await createPreloadedSadhana();
    sadhanaDAO.getAll().then((dbSadhanas) {
      setState(() {
        sadhanas = CacheData.getSadhanas();
        SyncActivityUtils.syncAllUnSyncActivity(context: context);
      });
    });
  }

  void addNewSadhana(Sadhana sadhana) {
    sadhanas.add(sadhana);
  }

  Future<void> createPreloadedSadhana() async {
    if (!await AppSharedPrefUtil.isCreatedPreloadedSadhana()) {
      Response res = await _api.getSadhanas();
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        List<Sadhana> sadhanaList = Sadhana.fromJsonList(appResponse.data);
        print(sadhanaList);
        for (Sadhana sadhana in sadhanaList) {
          await sadhanaDAO.insertOrUpdate(sadhana);
        }
        askForPreloadActivity(sadhanaList);
        AppSharedPrefUtil.saveCreatedPreloadedSadhana(true);
      }
    }
  }

  void askForPreloadActivity(List<Sadhana> sadhanaList) {
    CommonFunction.alertDialog(
      context: context,
      msg: "Do you want to load preload sadhana activity from server?",
      doneButtonFn: () {
        Navigator.pop(context);
        loadPreloadedActivity(sadhanaList);
      },
      showCancelButton: true,
    );
  }

  void loadPreloadedActivity(List<Sadhana> sadhanas) async {
    setState(() {
      isOverlay = true;
    });
    try {
      Response res = await _api.getActivity();
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        List<dynamic> wsActivities = appResponse.data;
        List<WSSadhanaActivity> wsSadhanaActivity = wsActivities.map((wsActivity) => WSSadhanaActivity.fromJson(wsActivity)).toList();
        Map<String, Sadhana> sadhanaByServerSName = new Map();
        sadhanas.forEach((sadhana) {
          sadhanaByServerSName[sadhana.serverSName] = sadhana;
        });
        for (WSSadhanaActivity wsSadhana in wsSadhanaActivity) {
          Sadhana sadhana = sadhanaByServerSName[wsSadhana.name];
          if (sadhana != null) {
            for (WSActivity wsActivity in wsSadhana.data) {
              if (wsActivity.date != null) {
                Activity activity = Activity(
                  sadhanaId: sadhana.id,
                  sadhanaDate: wsActivity.date,
                  sadhanaValue: wsActivity.value,
                  isSynced: true,
                  remarks: wsActivity.remark,
                );
                await activityDAO.insertOrUpdate(activity);
              }
            }
          }
        }
        setState(() {
          isOverlay = false;
        });
      }
    } catch (error) {
      print(error);
      CommonFunction.displayErrorDialog(context: context);
      setState(() {
        isOverlay = false;
      });
    }
  }

  @override
  //Widget build(BuildContext context) {
  Widget pageToDisplay() {
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
          ],
        ),
      ),
      bottomNavigationBar: CacheData.lastSyncTime != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text('Sync Upto: ' + CacheData.lastSyncTime),
                )
              ],
            )
          : null,
    );
  }

  _onAddSadhanaClick() {
    showDialog(context: context, builder: (_) => CreateSadhanaDialog(onDone: addNewSadhana)).then((value) {
      setState(() {});
    });
  }

  List<Widget> _buildLeftPanel() {
    List<Widget> widgets = new List();
    widgets.add(_mainHeaderTitle('<<' + Constant.monthName[today.month - 1] + '>>'));
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
      return SadhanaHorizontalPanel(sadhana: sadhana, daysToDisplay: daysToDisplay);
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

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.sync),
        onPressed: _onSyncClicked,
        tooltip: 'Sync Data',
      ),
      IconButton(
        icon: Icon(Icons.add),
        onPressed: _onAddSadhanaClick,
        tooltip: 'Add new Sadhana',
      ),
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
                title: Text('Share CSV'),
              ),
              value: 'share_excel',
            ),
            PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.settings, color: Colors.blueGrey),
                title: Text('Options'),
              ),
              value: 'options',
            ),
            PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.data_usage, color: Colors.orange),
                title: Text('Attendance App'),
              ),
              value: 'attendance',
            ),
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
    DateTime toDate = new DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    return await AppCSVUtils.generateCSVBetween(selectedMonth, toDate);
  }

  void _onSyncClicked() async {
    //Navigator.pushNamed(context, RegistrationPage.routeName);
    try {
      if (await AppUtils.isInternetConnected()) {
        setState(() {
          isOverlay = true;
        });
        if (await SyncActivityUtils.syncAllUnSyncActivity(onBackground: false, context: context)) {
          CommonFunction.alertDialog(context: context, msg: "Successfully all activity of preloaded sadhana is synced with server.");
        }
      } else {
        CommonFunction.alertDialog(context: context, msg: "Please connect to internet to sync");
      }
    } catch (error) {
      print(error);
      CommonFunction.displayErrorDialog(context: context);
    }
    setState(() {
      isOverlay = false;
    });
  }

  void onShareExcel() {
    showMonthPicker(context: context, initialDate: selectedDate ?? initialDate).then((date) => shareExcel(date));
  }

  shareExcel(date) async {
    if (date != null) {
      File file = await getGeneratedCSVPath(date);
      if (file != null) {
        final RenderBox box = context.findRenderObject();
        ShareExtend.share(file.path, "file");
        //Share.file(title: basename(file.path), path: file.path, text: basename(file.path))
        //    .share(sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }
    }
  }

  void onSaveExcel() {
    showMonthPicker(context: context, initialDate: selectedDate ?? initialDate).then((date) => saveExcel(date));
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
              openFile(file);
            });
      }
    }
  }

  openFile(File file) async {
    try {
      String uriToShare = file.uri.toString();
      // at this point uriToShare looks like: 'file:///storage/emulated/0/jpg_example.jpg'
      uriToShare = uriToShare.replaceFirst("file://", "content://");
      if (await canLaunch(uriToShare)) {
        await launch(uriToShare);
      } else {}
    } catch (error) {
      print(error);
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
