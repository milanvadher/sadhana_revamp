import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/attendance/model/user_access.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

import 'model/event.dart';

class AttendanceUtils {
  static ApiService _api = ApiService();

  static String getSessionName(dynamic data) {
    List<dynamic> names = (data as List);
    if(names != null && names.isNotEmpty)
      return names.first;
  }

  static void addEmptySessionIfAbsent(Event event) {
    if (event.sessions == null || event.sessions.isEmpty) {
      Session session = Session();
      session.date = event.startDate;
      event.sessions = List();
      event.sessions.add(session);
    }
  }

  static bool isOtherGroupMBA(UserAccess userAccess) {
    return userAccess != null && AppUtils.equalsIgnoreCase(userAccess.myAttendanceType, 'Event');
  }

  /*static Future<DateTime> getAttendanceMonthPending(String group, String event_name, BuildContext context) async {
    Response res = await _api.getMonthPendingForAttendance(null);
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.status == WSConstant.SUCCESS_CODE) {
      if (!AppUtils.isNullOrEmpty(appResponse.data)) {
        return WSConstant.wsDateFormat.parse(appResponse.data);
      } else
        return null;
    }
    return null;
  }*/
}
