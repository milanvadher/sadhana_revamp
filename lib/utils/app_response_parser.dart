import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/message_constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AppResponseParser {
  static AppResponse parseResponse(Response res, {BuildContext context, bool showDialog = true}) {
    ApiService _api = new ApiService();
    ServerResponse serverResponse;
    if (res.statusCode == 500 || res.statusCode == 502)
      serverResponse = new ServerResponse(appResponse: AppResponse(status: res.statusCode, msg: MessageConstant.COMMON_ERROR_MSG));
    else {
      try {
        serverResponse = ServerResponse.fromJson(json.decode(res.body));
      } catch(error) {
        print(error);
        serverResponse = new ServerResponse(appResponse: AppResponse(status: res.statusCode, msg: MessageConstant.COMMON_ERROR_MSG));
      }
    }
    AppResponse appResponse = serverResponse.appResponse;
    if (appResponse.status == 0 || appResponse.status == null) appResponse.status = res.statusCode;
    if (appResponse.msg == null) appResponse.msg = res.reasonPhrase;
    if (showDialog && appResponse.status != WSConstant.SUCCESS_CODE) {
      if (context != null) {
        CommonFunction.alertDialog(
          context: context,
          title: 'Error - ' + appResponse.status.toString(),
          msg: appResponse.msg != null ? appResponse.msg : MessageConstant.COMMON_ERROR_MSG,
          doneButtonText: 'Okay',
        );
      }
    }
    if (appResponse.status == 227) {
      _api.logout();
      Navigator.pushNamedAndRemoveUntil(context, '/login_new', (_) => false);
    }
    return appResponse;
  }
}
