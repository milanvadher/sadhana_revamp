import 'package:flutter/material.dart';
import 'package:sadhana/widgets/base_state.dart';

class AttendanceHomePage extends StatefulWidget {
  static const String routeName = '/attendance_home';

  @override
  AttendanceHomePageState createState() => AttendanceHomePageState();
}

class AttendanceHomePageState extends BaseState<AttendanceHomePage> {

  @override
  void initState() {
    super.initState();
  }


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
  Widget pageToDisplay() {
    return home;
  }
}
