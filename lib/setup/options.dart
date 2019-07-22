import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/other/about.dart';
import 'package:sadhana/service/dbprovider.dart';
import 'package:sadhana/setup/themes.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'package:sadhana/widgets/action_item.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/them_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  const AppOptionsPage({
    Key key,
    this.options,
    this.onOptionsChanged,
  }) : super(key: key);

  final AppOptions options;
  final ValueChanged<AppOptions> onOptionsChanged;

  @override
  _AppOptionsPageState createState() => _AppOptionsPageState();
}

class _AppOptionsPageState extends BaseState<AppOptionsPage> {
  bool isAllowSyncFromServer = false;
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

  @override
  Widget pageToDisplay() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _Heading('Settings'),
            Column(
              children: <Widget>[
                Divider(height: 0),
                //_ActionItem(Icons.person_outline, Constant.colors[0], 'Profile', () {}, 'View/Edit your profile'),
                ThemeItem(widget.options, onThemeChanged),
                isAllowSyncFromServer
                    ? ActionItem(Icons.cloud_download, Constant.colors[3], 'Load Data From Server', loadPreloadedActivity,
                        'Load your sadhana data from server')
                    : Container(),
                ActionItem(Icons.file_download, Constant.colors[4], 'Backup Data', _onBackup, 'Backup your data'),
              ],
            ),
          ]..addAll(<Widget>[
              _Heading('Sadhana App'),
              Column(
                children: <Widget>[
                  Divider(height: 0),
                  ActionItem(Icons.info_outline, Constant.colors[12], 'About', openAboutPage, 'About Sadhana App and report bug'),
                ],
              ),
            ]),
        ),
      ),
    );
  }

  void onThemeChanged(AppOptions newOptions) {
    setState(() {
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
}
