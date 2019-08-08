// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_app_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSAppSetting _$WSAppSettingFromJson(Map<String, dynamic> json) {
  return WSAppSetting(
      appVersionAndroid: json['app_version_android'] as String,
      appVersionIos: json['app_version_ios'] as String,
      editableDays: json['editable_days'] as int ?? 4,
      periodicSyncIntervalInMin: json['periodic_sync_interval'] as int ?? 5,
      allowSyncFromServer:
          AppUtils.convertToIntToBool(json['allow_sync_from_server'] as int),
      showCSVOption:
          AppUtils.convertToIntToBool(json['show_csv_option'] as int));
}

Map<String, dynamic> _$WSAppSettingToJson(WSAppSetting instance) =>
    <String, dynamic>{
      'app_version_android': instance.appVersionAndroid,
      'app_version_ios': instance.appVersionIos,
      'editable_days': instance.editableDays,
      'periodic_sync_interval': instance.periodicSyncIntervalInMin,
      'allow_sync_from_server':
          AppUtils.convertBoolToInt(instance.allowSyncFromServer),
      'show_csv_option': AppUtils.convertBoolToInt(instance.showCSVOption)
    };
