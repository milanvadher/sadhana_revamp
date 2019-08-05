

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_file_util.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class MBAScheduleCheck {
  static ApiService _apiService = ApiService();
  static void startAppUpdateCheckThread() {
    Future.delayed(Duration(seconds: 1), () => (){});
  }

  static Future<File> getMBASchedule({BuildContext context}) async {
    if(await AppSharedPrefUtil.isUserRegistered()) {
      String prefFilePath = await getCurrentMonthScheduleFromStorage();
      if(prefFilePath != null) {
        File scheduleFile = File(prefFilePath);
        if(await scheduleFile.exists())
          return scheduleFile;
      }
      if(await AppUtils.isInternetConnected()) {
        String date = DateFormat(WSConstant.DATE_FORMAT).format(DateTime.now());
        String center = WSConstant.center_Simcity;
        Profile profile = await CacheData.getUserProfile();
        if(profile != null && AppUtils.isNullOrEmpty(profile.center))
          center = profile.center;
        Response res = await _apiService.getMBASchedule(center, date);
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if(appResponse.status == WSConstant.SUCCESS_CODE) {
          String fileUrl = appResponse.data;
          if(AppUtils.isNullOrEmpty(fileUrl)) {
            CommonFunction.alertDialog(context: context, msg: "No schedule is available, Please try after some time.");
            return null;
          }
          String dir = await AppFileUtil.getMBAScheduleDir();
          File file = await AppFileUtil.saveImage(_apiService.getMBAScheduleAbsoluteUrl(fileUrl), dir);
          AppSharedPrefUtil.saveMBASchedule(DateTime.now(), file.path);
          return file;
        }
      } else {
        CommonFunction.displayInternetNotAvailableDialog(context: context);
      }
    }
    return null;
  }

  static Future<String> getCurrentMonthScheduleFromStorage() async {
    DateTime prefMonth = await AppSharedPrefUtil.getMBAScheduleMonth();
    if(prefMonth != null && DateTime.now().month == prefMonth.month) {
      return await AppSharedPrefUtil.getMBAScheduleFilePath();
    }
    return null;
  }

}