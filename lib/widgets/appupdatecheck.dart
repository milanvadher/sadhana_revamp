import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/version.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/WSAppSetting.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AppUpdateCheck {
  static bool isAreladyChecking = false;
  static void startAppUpdateCheckThread(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () => AppUpdateCheck().checkForNewAppUpdate(context));
  }

  ApiService _api = ApiService();

  void checkForNewAppUpdate(BuildContext context) async {
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
    if (await AppUtils.isInternetConnected() && !isAreladyChecking) {
      isAreladyChecking = true;
      Response res = await _api.getAppSetting();
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        AppSetting appSetting = AppSetting.fromJson(appResponse.data);
        if (appSetting.version != null) {
          String version = await AppSettingUtil.getAppVersion();
          Version currentVersion = Version(version: version);
          Version playStoreVersion = Version(version: appSetting.version);
          if (playStoreVersion.compareTo(currentVersion) > 0) {
            showUpdateDialog(context: context);
          }
        }
      }
    }

    //}
  }

  void showUpdateDialog({
    @required BuildContext context,
  }) {
    CommonFunction.alertDialog(
      context: context,
      msg: "New App Version is avaliable.\n You need to update the app to continue ... !!",
      title: "App Updatee",
      closeable: false,
      doneButtonText: "Update Now",
      type: 'success',
      doneButtonFn: () {
        isAreladyChecking = false;
        onUpdateNow(context);
      },
    );
    /*showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 2, left: 2),
            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Center(child: Text("App Update")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "New App Version is avaliable.\n You need to update the app to continue ... !!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueGrey, height: 1.5),
                    textScaleFactor: 1.1,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      color: kQuizMain500,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(
                        "Update Now",
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        onUpdateNow(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );*/
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
