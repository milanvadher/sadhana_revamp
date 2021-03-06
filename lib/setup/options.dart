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
import 'package:sadhana/widgets/base_state.dart';

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

class _ActionItem extends StatelessWidget {
  const _ActionItem(this.icon, this.iconColor, this.text, this.onTap, this.subtitle);
  final IconData icon;
  final List<Color> iconColor;
  final String text;
  final VoidCallback onTap;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            child: Icon(
              icon,
              color: theme == Brightness.light ? iconColor[0] : iconColor[1],
            ),
            backgroundColor: theme == Brightness.light ? iconColor[0].withAlpha(20) : iconColor[1].withAlpha(20),
          ),
          title: Text(text),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        Divider(height: 0),
      ],
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem(this.options, this.onOptionsChanged);

  final AppOptions options;
  final ValueChanged<AppOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _BooleanItem(
          options.theme == kDarkAppTheme ? Icons.brightness_high : Icons.brightness_low,
          Colors.grey,
          'Dark Theme',
          options.theme == kDarkAppTheme,
          (bool value) {
            onOptionsChanged(
              options.copyWith(
                theme: value ? kDarkAppTheme : kLightAppTheme,
              ),
            );
          },
          switchKey: const Key('dark_theme'),
        ),
        Divider(height: 0),
      ],
    );
  }
}

class _BooleanItem extends StatelessWidget {
  const _BooleanItem(this.icon, this.iconColor, this.title, this.value, this.onChanged, {this.switchKey});

  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  // [switchKey] is used for accessing the switch from driver tests.
  final Key switchKey;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: CircleAvatar(
        child: Icon(
          icon,
          color: iconColor,
        ),
        backgroundColor: iconColor.withAlpha(20),
      ),
      title: Text(title),
      subtitle: Text('Customise app theme'),
      trailing: Switch(
        key: switchKey,
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF39CEFD),
        activeTrackColor: isDark ? Colors.white30 : Colors.black26,
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
    AppSettingUtil.getServerAppSetting().then((appSetting) async{
      if (appSetting != null) {
        if(await AppSharedPrefUtil.isUserRegistered()) {
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
                _ThemeItem(widget.options, widget.onOptionsChanged),
                isAllowSyncFromServer
                    ? _ActionItem(Icons.cloud_download, Constant.colors[3], 'Load Data From Server', loadPreloadedActivity,
                        'Load your sadhana data from server')
                    : Container(),
                _ActionItem(Icons.file_download, Constant.colors[4], 'Backup Data', _onBackup, 'Backup your data'),
              ],
            ),
          ]..addAll(<Widget>[
              _Heading('Sadhana App'),
              Column(
                children: <Widget>[
                  Divider(height: 0),
                  _ActionItem(
                      Icons.info_outline, Constant.colors[12], 'About', openAboutPage, 'About Sadhana App and report bug'),
                ],
              ),
            ]),
        ),
      ),
    );
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
    if(await AppUtils.isInternetConnected()) {
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
      CommonFunction.displayInernetNotAvailableDialog(context: context);
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
    } catch (error) {
      print('Error while exporting backup:');
      print(error);
      CommonFunction.displayErrorDialog(context: context);
    }
    setState(() {
      isOverlay = false;
    });
  }
}
