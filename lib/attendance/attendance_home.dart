import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AttendanceHomePage extends StatefulWidget {
  static const String routeName = '/attendance_home';

  @override
  AttendanceHomePageState createState() => AttendanceHomePageState();
}

class AttendanceHomePageState extends BaseState<AttendanceHomePage> {
  static DateTime today = DateTime.now();
  ApiService _api = ApiService();
  Session session;
  Map<String, Attendance> mbaAttendance;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    startLoading();
    UserRole userRole = await AppSharedPrefUtil.getUserRole();
    if (userRole != null) {
      Response res = await _api.getMBAAttendance(DateFormat(WSConstant.DATE_FORMAT).format(today), userRole.groupName);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        session = Session.fromJson(appResponse.data);
        print(session);
      }
    }
    stopLoading();
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
