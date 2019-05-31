import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/wsmodel/WSAppSetting.dart';
import 'package:sadhana/wsmodel/appresponse.dart';
import 'package:synchronized/synchronized.dart';

import 'apputils.dart';

class AppSettingUtil {
  static AppSetting appSetting;
  static ApiService _api = ApiService();
  static Lock lock = new Lock();
  static Future<AppSetting> getServerAppSetting({forceFromServer = false}) async {
    return await lock.synchronized(() async {
      if (appSetting == null || forceFromServer) {
        if (await AppUtils. isInternetConnected()) {
          appSetting = await loadServerAppSetting();
        }
        if(appSetting == null)
          appSetting = await AppSharedPrefUtil.getServerSetting();
      }
      return appSetting;
    });
  }

  static Future<AppSetting> loadServerAppSetting() async {
    try {
      Response res = await _api.getAppSetting();
      AppSetting fromServerSetting;
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: null);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        fromServerSetting = AppSetting.fromJson(appResponse.data);
        appSetting = fromServerSetting;
        await AppSharedPrefUtil.saveServerSetting(appSetting);
      }
    } catch (error) {
      print(error);
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
