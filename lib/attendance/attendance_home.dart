import 'package:flutter/material.dart';

class AttendanceHomePage extends StatefulWidget {
  static const String routeName = '/attendance_home';

  @override
  AttendanceHomePageState createState() => AttendanceHomePageState();
}

class AttendanceHomePageState extends State<AttendanceHomePage> {
  Widget home = Scaffold(
    appBar: AppBar(
      title: Text('AttendanceHome Page'),
    ),
    body: SafeArea(
      child: Center(
        child: Text('AttendanceHome Page Data'),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return home;
  }
}
