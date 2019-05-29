import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission/permission.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:connectivity/connectivity.dart';

class AppUtils {
  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static bool isInteger(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  static askForPermission() async {
    List<PermissionName> permissions = [PermissionName.Storage];
    if (Platform.isAndroid) {
      await Permission.requestPermissions(permissions);
    } else {
      for (PermissionName permissionName in permissions) await Permission.requestSinglePermission(permissionName);
    }
  }

  static bool isLightBrightness(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }

  static bool isSadhanaExist(String name) {
    for (Sadhana sadhana in CacheData.getSadhanas()) {
      if (equalsIgnoreCase(sadhana.sadhanaName, name)) return true;
    }
    return false;
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static vibratePhone({int duration}) {
    Vibration.hasVibrator().then((canVibrate) {
      if (canVibrate) {
        if (duration != null && duration > 0)
          Vibration.vibrate(duration: duration);
        else
          Vibration.vibrate();
      }
    });
  }

  static Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  static launchStoreApp() {
    return Platform.isIOS ? launchAppstoreApp() : launchPlaystoreApp();
  }

  static void launchPlaystoreApp() async {
    String appId = await AppSettingUtil.getAppID();
    launch(Constant.BASE_PLAYSTORE_URL + appId);
    /*LaunchReview.launch(androidAppId: "org.dadabhagwan.AKonnect",
        iOSAppId: "585027354");*/
  }

  static void launchAppstoreApp() async {
    String appId = await AppSettingUtil.getAppID();
    launch(Constant.BASE_APPSTORE_URL);
    /*LaunchReview.launch(androidAppId: "org.dadabhagwan.AKonnect",
        iOSAppId: "585027354");*/
  }

  static void showInSnackBar(BuildContext context, String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }
}
