import 'package:flutter/material.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/model/version.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/WSAppSetting.dart';
import 'package:synchronized/synchronized.dart';

class AppUpdateCheck {
  static bool isAreladyChecking = false;
  static var lock = new Lock();
  static void startAppUpdateCheckThread(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () => AppUpdateCheck().checkForNewAppUpdate(context));
  }

  void checkForNewAppUpdate(BuildContext context, {forceSetting = false}) async {
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
      AppSetting appSetting = await AppSettingUtil.getServerAppSetting();
      if (appSetting != null && appSetting.version != null) {
        String version = await AppSettingUtil.getAppVersion();
        Version currentVersion = Version(version: version);
        Version playStoreVersion = Version(version: appSetting.version);
        if (playStoreVersion.compareTo(currentVersion) > 0) {
          showUpdateDialog(context: context);
        }
      }
    }
    isAreladyChecking = false;

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
