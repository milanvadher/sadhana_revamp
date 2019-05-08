import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sadhana/auth/login.dart';
import 'package:sadhana/sadhana/time-table.dart';
import 'package:sadhana/setup/options.dart';
import '../attendance/attendance_home.dart';
import '../sadhana/home.dart';

class CreateRoute {
  const CreateRoute({
    @required this.title,
    this.subtitle,
    @required this.routeName,
    @required this.buildRoute,
  }) : assert(title != null),
       assert(routeName != null),
       assert(buildRoute != null);

  final String title;
  final String subtitle;
  final String routeName;
  final WidgetBuilder buildRoute;

  @override
  String toString() {
    return '$runtimeType($title $routeName)';
  }
}

List<CreateRoute> _buildAppRoutes() {
  final List<CreateRoute> appRoutes = <CreateRoute>[
    CreateRoute(
      title: 'Login Page',
      routeName: LoginPage.routeName,
      buildRoute: (BuildContext context) => LoginPage(),
    ),
    CreateRoute(
      title: 'SadhanaHome Page',
      routeName: HomePage.routeName,
      buildRoute: (BuildContext context) => HomePage(),
    ),
    CreateRoute(
      title: 'AttendanceHome Page',
      routeName: AttendanceHomePage.routeName,
      buildRoute: (BuildContext context) => AttendanceHomePage(),
    ),
    CreateRoute(
      title: 'Time-Table Page',
      routeName: TimeTablePage.routeName,
      buildRoute: (BuildContext context) => TimeTablePage(),
    )
  ];
  return appRoutes;
}

final List<CreateRoute> kAllAppRoutes = _buildAppRoutes();