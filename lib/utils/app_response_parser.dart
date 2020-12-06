import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/login/login.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/message_constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/service/dbprovider.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AppResponseParser {
  static AppResponse parseResponse(Response res, {@required BuildContext context, bool showDialog = true}) {
    ApiService _api = new ApiService();
    ServerResponse serverResponse;
    if (res.statusCode == 226 || res.statusCode == 403) {
      logout(context);
    } else {
      if (res.statusCode == 500 || res.statusCode == 502)
        serverResponse = new ServerResponse(appResponse: AppResponse(status: res.statusCode, msg: MessageConstant.COMMON_ERROR_MSG , data: res.body));
      else {
        try {
          serverResponse = ServerResponse.fromJson(json.decode(res.body));
        } catch (error, s) {
          print(error);
          print(s);
          serverResponse = new ServerResponse(appResponse: AppResponse(status: res.statusCode, msg: MessageConstant.COMMON_ERROR_MSG, data: error));
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
            //title: 'Error',
            msg: appResponse.msg != null ? appResponse.msg : MessageConstant.COMMON_ERROR_MSG,
            type: 'error',
            doneButtonText: 'OK',
            errorHint: appResponse.data,
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

  static logout(BuildContext context) async {
    CommonFunction.alertDialog(
        closeable: false,
        context: context,
        msg: 'You are already logged in another device so You are going to logout in this device',
        type: 'error',
        doneButtonFn: () {
          _exportDB(context);
        });
  }

  static _exportDB(BuildContext context) async {
    try {
      void logout2() async {
        DBProvider db = await DBProvider.db;
        db.deleteDB();
        await AppSharedPrefUtil.clear();
        CacheData.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
            (_) => false);
      }

      File exportedFile = await DBProvider.db.exportDB();
      if (exportedFile != null) {
        CommonFunction.alertDialog(
          closeable: false,
          context: context,
          msg: 'Your Backup file is generated at ${exportedFile.path}',
          doneButtonFn: logout2,
        );
      }
    } catch (error, s) {
      print('Error while exporting backup:');
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context, error: error.toString());
    }
  }
}
