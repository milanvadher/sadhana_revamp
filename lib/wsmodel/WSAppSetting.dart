import 'dart:io';

import 'package:sadhana/utils/app_setting_util.dart';

class AppSetting {
  static const int DEFAULT_EditableDays = 15;
  static const int DEFAULT_periodicSyncIntervalInMin = 5;
  String appVersionAndroid;
  String appVersionIos;
  String editableDays;
  String serverDate;
  int periodicSyncIntervalInMin = DEFAULT_periodicSyncIntervalInMin;
  String get version => Platform.isIOS ? appVersionIos : appVersionAndroid;

  AppSetting(
      {this.appVersionAndroid,
      this.appVersionIos,
      this.editableDays = '3',
      this.serverDate,
      this.periodicSyncIntervalInMin = DEFAULT_periodicSyncIntervalInMin});

  static Future<AppSetting> getDefaulServerAppSetting() async {
    String appVersion = await AppSettingUtil.getAppVersion();
    return AppSetting(appVersionAndroid: appVersion, appVersionIos: appVersion);
  }

  AppSetting.fromJson(Map<String, dynamic> json) {
    appVersionAndroid = json['app_version_android'];
    appVersionIos = json['app_version_ios'];
    editableDays = json['editable_days'] ?? DEFAULT_EditableDays;
    serverDate = json['server_date'];
    periodicSyncIntervalInMin = json['periodic_sync_interval'] ?? DEFAULT_periodicSyncIntervalInMin;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_version_android'] = this.appVersionAndroid;
    data['app_version_ios'] = this.appVersionIos;
    data['editable_days'] = this.editableDays;
    data['server_date'] = this.serverDate;
    return data;
  }
}
