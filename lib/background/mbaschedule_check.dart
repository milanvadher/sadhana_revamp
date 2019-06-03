

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_file_util.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class MBAScheduleCheck {
  static bool isAreladyChecking = false;
  static ApiService _apiService = ApiService();
  static void startAppUpdateCheckThread() {
    Future.delayed(Duration(seconds: 1), () => (){});
  }

  static Future<File> getMBASchedule({BuildContext context}) async {
    String date = DateFormat(WSConstant.DATE_FORMAT).format(DateTime.now());
    Response res = await _apiService.getMBASchedule('Sim-City', date);
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if(appResponse.status == WSConstant.SUCCESS_CODE) {
      String fileUrl = appResponse.data;
      String dir = await AppFileUtil.getMBAScheduleDir();
      return await AppFileUtil.saveImage(_apiService.getMBAScheduleAbsoluteUrl(fileUrl), dir);
    }
    return null;
  }

}