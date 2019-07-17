import 'dart:async';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:sadhana/auth/login/login.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/notification/app_local_notification.dart';
import 'package:sadhana/sadhana/home.dart';
import 'package:sadhana/setup/options.dart';
import 'package:sadhana/setup/routes.dart';
import 'package:sadhana/setup/themes.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SadhanaApp extends StatefulWidget {
  const SadhanaApp({Key key}) : super(key: key);

  @override
  _SadhanaAppState createState() => _SadhanaAppState();
}

class _SadhanaAppState extends State<SadhanaApp> {
  AppOptions _options;
  Widget pageToDisplay = Container();
  @override
  initState() {
    super.initState();
    _options = AppOptions(
      theme: kDarkAppTheme,
      platform: defaultTargetPlatform,
    );
    new Future.delayed(Duration.zero, () {
      AppLocalNotification.initAppLocalNotification(context);
    });
    _getUserSelectedTheme();
    checkForUserLoggedIn();
  }

  void checkForUserLoggedIn() {
    getAppOptionPage();
    //pageToDisplay = AttendanceHomePage();
    AppSharedPrefUtil.isUserLoggedIn().then((isLoggedIn) {
      if(isLoggedIn) {
        setState(() {
          pageToDisplay = HomePage(
            optionsPage: getAppOptionPage(),
          );
        });
      } else {
        setState(() {
          pageToDisplay = LoginPage();
        });
      }
    });
  }

  AppOptionsPage getAppOptionPage() {
    AppOptionsPage appOptionsPage = AppOptionsPage(
      options: _options,
      onOptionsChanged: _handleOptionsChanged,
    );
    CommonFunction.appOptionsPage = appOptionsPage;
    return appOptionsPage;
  }

  void _getUserSelectedTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') != null ? prefs.getBool('isDarkMode') : false;
    setState(() {
      _options = AppOptions(theme: isDarkMode ? kDarkAppTheme : kLightAppTheme, platform: defaultTargetPlatform);
    });
  }

  @override
  Widget build(BuildContext context) {
    //checkForUserLoggedIn();
    return MaterialApp(
      theme: _options.theme.data.copyWith(platform: _options.platform),
      title: 'Sadhana',
      color: Colors.grey,
      routes: _buildRoutes(),
      home: pageToDisplay,
    );
  }

  void _handleOptionsChanged(AppOptions newOptions) async {
    try {
      setState(() {
        _options = newOptions;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDarkMode', newOptions.theme == kLightAppTheme ? false : true);
    } catch(e,s) {
      print(e); print(s);
    }
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return Map<String, WidgetBuilder>.fromIterable(
      kAllAppRoutes,
      key: (dynamic demo) => '${demo.routeName}',
      value: (dynamic demo) => demo.buildRoute,
    );
  }
}
