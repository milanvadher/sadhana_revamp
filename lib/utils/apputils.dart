import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
//import 'package:permission/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:vibration/vibration.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';

class AppUtils {
  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  static bool isNullOrEmpty(String str) {
    return str == null || str.trim().isEmpty;
  }

  static bool convertToIntToBool(int input, {bool defaultValue = false}) {
    if (input == null) {
      return defaultValue;
    } else {
      if (input > 0)
        return true;
      else
        return false;
    }
  }
  static int convertBoolToInt(bool boolValue, {int defaultValue = 0}) {
    return boolValue != null ? (boolValue ? 1 : 0) : defaultValue;
  }

  static String getCountTitleForSadhana(String sadhanaName) {
    if (AppUtils.equalsIgnoreCase(sadhanaName, Constant.SEVANAME))
      return 'Hours';
    else if (AppUtils.equalsIgnoreCase(sadhanaName, Constant.vanchanName))
      return 'Pages';
    else
      return 'Counts';
  }

  static String listToString(List<dynamic> data) {
    String values = '';
    if(data != null && data.isNotEmpty) {
      data.forEach((s) => AppUtils.isNullOrEmpty(s.toString()) ? '' : values = '$values, ${s.toString()}');
      if(values.length > 1)
        values = values.substring(1, values.length);
    }
    return values;
  }

  static bool isDarkTheme(BuildContext context) {
    return Brightness.dark == Theme.of(context).brightness;
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

  static DateTime tryParse(String dateString, List<String> formats, {bool throwErrorIfNotParse = false}) {
    dynamic throwError;
    if(formats == null)
      formats = [WSConstant.DATE_TIME_FORMAT, WSConstant.DATE_TIME_FORMAT2, WSConstant.DATE_FORMAT];
    for (String format in formats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (error, s) {
        throwError = error;
        print('Cannot parse $dateString using $format');
      }
    }
    if (throwErrorIfNotParse) throw throwError;
  }

  static tryToExecute(int numOfTry, Function function) async {
    int tried = 0;
    while (tried < numOfTry) {
      try {
        return await function();
      } catch (error, s) {
        print('error on trying');
        print(error);
        print(s);
      }
      tried++;
    }
  }

  static Future<int> getAndroidOSVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  /*static askForPermission() async {
    List<PermissionName> permissions = [PermissionName.Storage];
    if (Platform.isAndroid) {
      if (await getAndroidOSVersion() >= 23) {
        //Marshmallow
        await Permission.requestPermissions(permissions);
      }
    } else {
      for (PermissionName permissionName in permissions) await Permission.requestSinglePermission(permissionName);
    }
  }

  static Future<bool> checkPermission() async {
    //await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    //bool checkPermission = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    await askForPermission();
    bool checkPermission;
    if (Platform.isAndroid) {
      if (await getAndroidOSVersion() >= 23) {
        List<Permissions> permissions = await Permission.getPermissionsStatus([PermissionName.Storage]);
        checkPermission = permissions.single.permissionStatus == PermissionStatus.allow ? true : false;
      } else
        checkPermission = true;
    } else {
      PermissionStatus permissionStatus = await Permission.getSinglePermissionStatus(PermissionName.Storage);
      checkPermission = permissionStatus == PermissionStatus.allow ? true : false;
    }
    return checkPermission;
  }*/

  static Future<bool> askForPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
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
    //  Vibration.hasVibrator().then((canVibrate) {
    //    if (canVibrate) {
    //      if (duration != null && duration > 0)
    //        Vibration.vibrate(duration: duration);
    //      else
    //        Vibration.vibrate();
    //    }
    //  });
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
  }

  static void launchAppstoreApp() async {
    String appId = await AppSettingUtil.getAppID();
    launch(Constant.BASE_APPSTORE_URL);
  }

  static void showInSnackBar(BuildContext context, String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  static List<T> fromJsonList<T>(dynamic json, Function(Map<String, dynamic>) fromJson) {
    return (json as List)?.map<T>((e) => e == null ? null : fromJson(e as Map<String, dynamic>))?.toList();
  }

  static Future<void> updateInternetDate() async {
    await CommonFunction.tryCatchAsync(null, () async {
      if(await AppUtils.isInternetConnected()) {
        DateTime internetDate = await NTP.now();
        if(internetDate != null) {
          await AppSharedPrefUtil.saveInternetDate(internetDate);
        }
      }
    });
  }
}
