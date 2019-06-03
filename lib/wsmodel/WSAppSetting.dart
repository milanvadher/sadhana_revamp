import 'dart:io';

import 'package:sadhana/utils/app_setting_util.dart';

class AppSetting {
  static const int DEFAULT_EditableDays = 15;
  static const int DEFAULT_periodicSyncIntervalInMin = 5;
  String appVersionAndroid;
  String appVersionIos;
  int editableDays;
  String serverDate;
  int periodicSyncIntervalInMin = DEFAULT_periodicSyncIntervalInMin;
  String get version => Platform.isIOS ? appVersionIos : appVersionAndroid;
  bool allowSyncFromServer;
  AppSetting(
      {this.appVersionAndroid,
      this.appVersionIos,
      this.editableDays =  DEFAULT_EditableDays,
      this.serverDate,
      this.periodicSyncIntervalInMin = DEFAULT_periodicSyncIntervalInMin,
      this.allowSyncFromServer = false});

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
    allowSyncFromServer = false;
    if(json['allow_sync_from_server'] != null)
      allowSyncFromServer = json['allow_sync_from_server'] > 0 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_version_android'] = this.appVersionAndroid;
    data['app_version_ios'] = this.appVersionIos;
    data['editable_days'] = this.editableDays;
    data['server_date'] = this.serverDate;
    data['allow_sync_from_server'] = this.allowSyncFromServer ? 1 : 0;
    return data;
  }
}
