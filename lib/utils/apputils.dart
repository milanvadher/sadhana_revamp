import 'package:flutter/material.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:vibration/vibration.dart';
import 'package:connectivity/connectivity.dart';

class AppUtils {
  static bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
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
}
