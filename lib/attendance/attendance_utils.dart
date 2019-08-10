import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AttendanceUtils {
  static ApiService _api = ApiService();

  static Future<DateTime> getAttendanceMonthPending(String group, BuildContext context) async {
    Response res = await _api.getMonthPendingForAttendance(group);
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.status == WSConstant.SUCCESS_CODE) {
      if (!AppUtils.isNullOrEmpty(appResponse.data)) {
        return WSConstant.wsDateFormat.parse(appResponse.data);
      } else
        return null;
    }
    return null;
  }
}
