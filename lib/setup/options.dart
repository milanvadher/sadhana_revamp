import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sadhana/attendance/attendance_summary.dart';
import 'package:sadhana/attendance/attendance_utils.dart';
import 'package:sadhana/attendance/event_attendance.dart';
import 'package:sadhana/attendance/model/attendance_summary.dart';
import 'package:sadhana/attendance/model/user_access.dart';
import 'package:sadhana/auth/profile/profile_page.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/notification/app_local_notification.dart';
import 'package:sadhana/other/about.dart';
import 'package:sadhana/profileSetting/centerChangeRequest.dart';
import 'package:sadhana/service/dbprovider.dart';
import 'package:sadhana/setup/themes.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'package:sadhana/widgets/action_item.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/boolean_item.dart';
import 'package:sadhana/widgets/them_item.dart';
import 'package:sadhana/wsmodel/ws_app_setting.dart';

class AppOptions {
  AppOptions({this.theme, this.platform});

  final AppTheme theme;
  final TargetPlatform platform;

  AppOptions copyWith({AppTheme theme}) {
    return AppOptions(theme: theme ?? this.theme, platform: platform);
  }

  @override
  String toString() {
    return '$theme';
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(color: theme.accentColor),
      ),
    );
  }
}

class AppOptionsPage extends StatefulWidget {
  AppOptionsPage({
    Key key,
    this.options,
    this.onOptionsChanged,
  }) : super(key: key);

  AppOptions options;
  final ValueChanged<AppOptions> onOptionsChanged;

  @override
  _AppOptionsPageState createState() => _AppOptionsPageState();
}

class _AppOptionsPageState extends BaseState<AppOptionsPage> {
  bool isAllowSyncFromServer = true;
  @override
  void initState() {
    super.initState();
    AppSettingUtil.getServerAppSetting().then((appSetting) async {
      if (appSetting != null) {
        if (await AppSharedPrefUtil.isUserRegistered()) {
          setState(() {
            isAllowSyncFromServer = appSetting.allowSyncFromServer;
          });
        }
      }
    });
  }

  loadData() async {
    WSAppSetting appSetting = await AppSettingUtil.getServerAppSetting();
    if (appSetting != null) {
      if (await AppSharedPrefUtil.isUserRegistered()) {
        isAllowSyncFromServer = appSetting.allowSyncFromServer;
      }
    }
  }

  @override
  Widget pageToDisplay() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _Heading('Profile'),
            ActionItem(
              Icons.person_outline,
              Constant.colors[0],
              'Edit Profile',
              onProfile,
              'View/Edit your profile',
              showRightIcon: true,
            ),
            ActionItem(
              Icons.calendar_today,
              Constant.colors[1],
              'My Attendance',
              onMyAttendance,
              'View My Attendance',
              showRightIcon: true,
            ),
            ActionItem(
              Icons.person_outline,
              Constant.colors[0],
              'Change Center',
              onChangeCenter,
              'Change your center',
              showRightIcon: true,
            ),
            _Heading('Settings'),
            Column(
              children: <Widget>[
                Divider(height: 0),
                ThemeItem(widget.options, onThemeChanged),
                isAllowSyncFromServer
                    ? ActionItem(Icons.cloud_download, Constant.colors[3], 'Load Data From Server', loadPreloadedActivity,
                        'Load your sadhana data from server')
                    : Container(),
                ActionItem(Icons.file_download, Constant.colors[4], 'Backup Data', _onBackup, 'Backup your data'),
                ActionItem(Icons.file_upload, Constant.colors[5], 'Import Data', _onImport,
                    'Import Data your data which hass been taken backup. Select .db file.'),
              ],
            ),
          ]..addAll(<Widget>[
              _Heading('Sadhana App'),
              Column(
                children: <Widget>[
                  Divider(height: 0),
                  ActionItem(
                    Icons.info_outline,
                    Constant.colors[12],
                    'About',
                    openAboutPage,
                    'About Sadhana App and report bug',
                    showRightIcon: true,
                  ),
                ],
              ),
            ]),
        ),
      ),
    );
  }

  void onThemeChanged(AppOptions newOptions) {
    setState(() {
      widget.options = newOptions;
      widget.onOptionsChanged(newOptions);
    });
    /*widget.onOptionsChanged(newOptions);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        prefs.setBool('isDarkMode', newOptions.theme == kLightAppTheme ? false : true);
      });
    });*/
  }

  void openAboutPage() {
    Navigator.pushNamed(context, About.routeName);
  }

  void onProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
  }

  void onMyAttendance() {
    UserAccess userAccess = CacheData.userAccess;
    if(AttendanceUtils.isOtherGroupMBA(userAccess)) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventAttendance(myAttendance: true, isMyAttendanceSummary: true,),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceSummaryPage(isMyAttendanceSummary: true),
          ));
    }

  }

  void onChangeCenter() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CenterChangeRequestPage(),
        ));
  }

  void askForSyncActivity() {
    CommonFunction.alertDialog(
        context: context,
        msg: "It's takes several minutes, Pls wait to compelete.",
        closeable: false,
        doneButtonText: 'OK',
        doneButtonFn: () {
          Navigator.pop(context);
          loadPreloadedActivity();
        });
  }

  void loadPreloadedActivity() async {
    if (await AppUtils.isInternetConnected()) {
      setState(() {
        isOverlay = true;
      });
      try {
        List<Sadhana> sadhanas = CacheData.getSadhanas();
        await SyncActivityUtils.loadActivityFromServer(sadhanas, context: context);
        CommonFunction.alertDialog(context: context, msg: "Successfully load sadhana data from Server.");
      } catch (error) {
        print(error);
        CommonFunction.displayErrorDialog(context: context);
      }
      setState(() {
        isOverlay = false;
      });
    } else {
      CommonFunction.displayInternetNotAvailableDialog(context: context);
    }
  }

  _onBackup() async {
    try {
      setState(() {
        isOverlay = true;
      });
      File exportedFile = await DBProvider.db.exportDB();
      if (exportedFile != null) {
        CommonFunction.alertDialog(context: context, msg: 'Your Backup file is generated at ${exportedFile.path}');
      }
    } catch (error, s) {
      print('Error while exporting backup:');
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    setState(() {
      isOverlay = false;
    });
  }

  _onImport() async {
    _openFileExplorer();
  }

  void _openFileExplorer() async {
    await CommonFunction.tryCatchAsync(context, () async {
      String _path = await FilePicker.getFilePath(type: FileType.any);
      if(_path != null) {
        if (_path.endsWith(".db")) {
          await importFile(_path);
          CommonFunction.alertDialog(
              context: context,
              msg: "File Imported Successfully",
              doneButtonFn: () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
        } else {
          CommonFunction.alertDialog(context: context, msg: "Select Valid File which have extension .db");
        }
      }
    });
  }

  void importFile(String _path) async {
    SadhanaDAO sFileDAO = SadhanaDAO.withDBProvider(DBProvider(await DBProvider.getDB(_path)));
    List<Sadhana> sadhanas = await sFileDAO.getAll(withAllActivity: true);
    SadhanaDAO sadhanaDBDAO = SadhanaDAO();
    sadhanas.forEach((sadhana) async {
      Sadhana dbSadhana = await sadhanaDBDAO.insertOrUpdate(sadhana);
      ActivityDAO activityDAO = ActivityDAO();
      sadhana.activitiesByDate.removeWhere((k, v) => v.sadhanaValue <= 0);
      sadhana.activitiesByDate.forEach((k, v) {
        v.sadhanaId = dbSadhana.id;
      });
      activityDAO.batchActivityInsertForSync(sadhana, sadhana.activitiesByDate.values.toList(growable: true));
      AppLocalNotification().scheduleSadhanaDailyAtTime(sadhana);
    });
  }
}
