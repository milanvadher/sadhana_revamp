import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/background/mbaschedule_check.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/version.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'package:sadhana/wsmodel/ws_app_setting.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

import '../main.dart';

class OnAppOpenBackgroundThread {
  static bool isChecking = false;
  final BuildContext context;

  ApiService api = ApiService();

  OnAppOpenBackgroundThread(this.context);

  static void startBackgroundThread(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () => OnAppOpenBackgroundThread(context).startThread());
  }

  startThread() async {
    CommonFunction.tryCatchAsync(context, () async {
      if(await AppUtils.isInternetConnected()) {
        if (await AppSharedPrefUtil.isUserRegistered()) {
          updateUserRole();
          SyncActivityUtils.syncAllUnSyncActivity(context: context);
          MBAScheduleCheck.getMBASchedule();
          await checkTokenExpiration();
        }
        AppUtils.updateInternetDate();
        await checkForNewAppUpdate();
      }
    });
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
      WSAppSetting appSetting = await AppSettingUtil.getServerAppSetting();
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



  static Future<bool> validateMobileDate(BuildContext context) async {
    DateTime internetDate = await AppSharedPrefUtil.getInternetDate();
    if (internetDate != null) {
      DateTime currentTime = DateTime.now();
      print("########### $currentTime $internetDate ${internetDate.difference(currentTime).inDays}" );
      if (currentTime.isBefore(internetDate) && internetDate.difference(currentTime).inDays >= 1) {
        print('############ Displayed dialog');
        CommonFunction.alertDialog(
          closeable: false,
          context: context,
          type: 'error',
          msg: "Your mobile date is not proper, Please change it and reopen App.",
          doneButtonFn: () {
            exit(0);
          },
        );
        return false;
      }
    }
    return true;
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
