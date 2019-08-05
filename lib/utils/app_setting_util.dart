import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/wsmodel/ws_app_setting.dart';
import 'package:sadhana/wsmodel/appresponse.dart';
import 'package:synchronized/synchronized.dart';

import 'apputils.dart';

class AppSettingUtil {
  static WSAppSetting appSetting;
  static ApiService _api = ApiService();
  static Lock lock = new Lock();
  static Future<WSAppSetting> getServerAppSetting({forceFromServer = false}) async {
    return await lock.synchronized(() async {
      if (appSetting == null || forceFromServer) {
        if (await AppUtils.isInternetConnected()) {
          appSetting = await loadServerAppSetting();
        }
        if(appSetting == null)
          appSetting = await AppSharedPrefUtil.getServerSetting();
      }
      return appSetting;
    });
  }

  static Future<WSAppSetting> loadServerAppSetting() async {
    try {
      Response res = await _api.getAppSetting();
      WSAppSetting fromServerSetting;
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: null);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        fromServerSetting = WSAppSetting.fromJson(appResponse.data);
        appSetting = fromServerSetting;
        await AppSharedPrefUtil.saveServerSetting(appSetting);
      }
    } catch (error,s) {
      print(error);print(s);
    }
    return appSetting;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getAppID() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appId = packageInfo.packageName;
    return appId;
  }
}
