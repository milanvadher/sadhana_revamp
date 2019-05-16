import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:sadhana/sadhana/home.dart';
import 'package:sadhana/setup/options.dart';
import 'package:sadhana/setup/routes.dart';
import 'package:sadhana/setup/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SadhanaApp extends StatefulWidget {
  const SadhanaApp({Key key}) : super(key: key);

  @override
  _SadhanaAppState createState() => _SadhanaAppState();
}

class _SadhanaAppState extends State<SadhanaApp> {
  AppOptions _options;

  @override
  initState() {
    super.initState();
    _options = AppOptions(
      theme: kDarkAppTheme,
      platform: defaultTargetPlatform,
    );
    _getUserSelectedTheme();
  }

  void _getUserSelectedTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') != null
        ? prefs.getBool('isDarkMode')
        : false;
    setState(() {
      _options = AppOptions(
          theme: isDarkMode ? kDarkAppTheme : kLightAppTheme,
          platform: defaultTargetPlatform);
    });
  }

  void _handleOptionsChanged(AppOptions newOptions) async {
    setState(() {
      _options = newOptions;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(
        'isDarkMode', newOptions.theme == kLightAppTheme ? false : true);
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return Map<String, WidgetBuilder>.fromIterable(
      kAllAppRoutes,
      key: (dynamic demo) => '${demo.routeName}',
      value: (dynamic demo) => demo.buildRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget home = HomePage(
      optionsPage: AppOptionsPage(
        options: _options,
        onOptionsChanged: _handleOptionsChanged,
      ),
    );

    return MaterialApp(
      theme: _options.theme.data.copyWith(platform: _options.platform),
      title: 'Sadhana',
      color: Colors.grey,
      routes: _buildRoutes(),
      home: home,
    );
  }
}
