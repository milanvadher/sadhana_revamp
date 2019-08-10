import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/apputils.dart';

part "ws_app_setting.g.dart";

@JsonSerializable()
class WSAppSetting {
  static const int DEFAULT_EditableDays = 4;
  static const int DEFAULT_periodicSyncIntervalInMin = 5;

  @JsonKey(name: 'app_version_android')
  String appVersionAndroid;
  @JsonKey(name: 'app_version_ios')
  String appVersionIos;
  String get version => Platform.isIOS ? appVersionIos : appVersionAndroid;

  @JsonKey(name: 'editable_days' , defaultValue: DEFAULT_EditableDays)
  int editableDays;

  @JsonKey(name: 'periodic_sync_interval', defaultValue: DEFAULT_periodicSyncIntervalInMin)
  int periodicSyncIntervalInMin = DEFAULT_periodicSyncIntervalInMin;

  @JsonKey(name: 'allow_sync_from_server', fromJson: AppUtils.convertToIntToBool , toJson: AppUtils.convertBoolToInt)
  bool allowSyncFromServer;

  @JsonKey(name: 'show_csv_option', fromJson: AppUtils.convertToIntToBool , toJson: AppUtils.convertBoolToInt)
  bool showCSVOption = false;

  WSAppSetting(
      {this.appVersionAndroid,
      this.appVersionIos,
      this.editableDays =  DEFAULT_EditableDays,
      this.periodicSyncIntervalInMin = DEFAULT_periodicSyncIntervalInMin,
      this.allowSyncFromServer = false,
      this.showCSVOption = false});

  static Future<WSAppSetting> getDefaulServerAppSetting() async {
    String appVersion = await AppSettingUtil.getAppVersion();
    return WSAppSetting(appVersionAndroid: appVersion, appVersionIos: appVersion);
  }

  factory WSAppSetting.fromJson(Map<String, dynamic> json) => _$WSAppSettingFromJson(json);
  Map<String, dynamic> toJson() => _$WSAppSettingToJson(this);

  @override
  String toString() {
    return 'WSAppSetting{appVersionAndroid: $appVersionAndroid, appVersionIos: $appVersionIos, editableDays: $editableDays, periodicSyncIntervalInMin: $periodicSyncIntervalInMin, allowSyncFromServer: $allowSyncFromServer, showCSVOption: $showCSVOption}';
  }


/*  WSAppSetting.fromJson(Map<String, dynamic> json) {
    appVersionAndroid = json['app_version_android'];
    appVersionIos = json['app_version_ios'];
    editableDays = json['editable_days'] ?? DEFAULT_EditableDays;
    periodicSyncIntervalInMin = json['periodic_sync_interval'] ?? DEFAULT_periodicSyncIntervalInMin;
    allowSyncFromServer = false;
    if(json['allow_sync_from_server'] != null)
      allowSyncFromServer = json['allow_sync_from_server'] > 0 ? true : false;
    if(json['show_csv_option'] != null)
      showCSVOption = json['show_csv_option'] > 0 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_version_android'] = this.appVersionAndroid;
    data['app_version_ios'] = this.appVersionIos;
    data['editable_days'] = this.editableDays;
    data['periodic_sync_interval'] = this.periodicSyncIntervalInMin ?? DEFAULT_periodicSyncIntervalInMin;
    data['allow_sync_from_server'] = this.allowSyncFromServer ? 1 : 0;
    data['show_csv_option'] = this.showCSVOption ? 1 : 0;
    return data;
  }*/
}
