import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/version.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/WSAppSetting.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

import '../main.dart';

class AppUpdateCheck {
  static bool isChecking = false;
  final BuildContext context;

  ApiService api = ApiService();

  AppUpdateCheck(this.context);

  static void startAppUpdateCheckThread(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () => AppUpdateCheck(context).startThread());
  }

  startThread() async {
    await updateUserRole();
    if(!await checkForNewAppUpdate()) {
      await checkTokenExpiration();
      //await checkServerDate();
    }
  }

  Future<bool> checkForNewAppUpdate() async {
    bool isUpdated = false;
    /*bool check = true;
    int checkAfter = await AppSharedPrefUtil.getAppUpdateCheckAfter();
    if (checkAfter > 0) {
      DateTime now = DateTime.now();
      DateTime after = new DateTime.fromMillisecondsSinceEpoch(checkAfter);
      if (now.isBefore(after)) {
        check = false;
      }
    }
    if (checkapp_setting_util.dart) {*/
    if (await AppUtils.isInternetConnected() && !isChecking) {
      isChecking = true;
      AppSetting appSetting = await AppSettingUtil.getServerAppSetting();
      if (appSetting != null && appSetting.version != null) {
        String version = await AppSettingUtil.getAppVersion();
        Version currentVersion = Version(version: version);
        Version playStoreVersion = Version(version: appSetting.version);
        if (playStoreVersion.compareTo(currentVersion) > 0) {
          showUpdateDialog(context: context);
          isUpdated = true;
        }
      }
    }
    isChecking = false;
    return isUpdated;
    //}
  }

  checkServerDate() async {
    DateTime internetDate = await AppSharedPrefUtil.getInternetDate();
    if (internetDate != null) {
      DateTime currentTime = DateTime.now();
      if (currentTime.isAfter(internetDate) && currentTime.difference(internetDate).inDays > 2) {
        CommonFunction.alertDialog(
          closeable: false,
          context: context,
          msg: "Your mobile date is not proper, Please change it and reopen App.",
          doneButtonFn: () {
            exit(0);
          },
        );
      }
    }
  }

  checkTokenExpiration() async {
    if (await AppSharedPrefUtil.isUserRegistered()) {
      Response res = await api.validateToken();
      AppResponseParser.parseResponse(res, context: context);
    }
  }

  updateUserRole() async {
    Response res = await api.getUserRole();
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.status == WSConstant.SUCCESS_CODE) {
      UserRole userRole = UserRole.fromJson(appResponse.data);
      if (userRole != null) {
        AppSharedPrefUtil.saveUserRole(userRole);
        main();
      }
    }
  }

  void showUpdateDialog({
    @required BuildContext context,
  }) {
    CommonFunction.alertDialog(
      context: context,
      msg: "New App Version is avaliable.\n You need to update the app to continue ... !!",
      title: "App Update",
      closeable: false,
      doneButtonText: "Update Now",
      type: 'success',
      doneButtonFn: () {
        isChecking = false;
        onUpdateNow(context);
      },
    );
  }

  void onUpdateNow(BuildContext context) {
    AppUtils.launchStoreApp();
  }

/*  void onRemindLater(BuildContext context) {
    DateTime today = new DateTime.now();
    DateTime twoDaysFromNow =
        today.add(new Duration(hours: AppConstant.REMIND_LATER_IN_HOURS));
    AppSharedPrefUtil.saveAppUpdateCheckAfter(
            twoDaysFromNow.millisecondsSinceEpoch)
        .then((isUpdated) {
      Navigator.pop(context);
    });
  }*/

  Widget getButton({@required BuildContext context, @required String text, Function onPressed}) {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
      color: kQuizMain500,
      child: Row(
        children: <Widget>[
          Text(
            text,
            textScaleFactor: 1.0,
            style: TextStyle(
              color: kQuizBackgroundWhite,
            ),
          )
        ],
      ),
      onPressed: () {
        onPressed != null ? onPressed() : Navigator.pop(context);
      },
    );
  }
}
