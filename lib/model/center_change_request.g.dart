// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'center_change_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CenterChangeRequest _$CenterChangeRequestFromJson(Map<String, dynamic> json) {
  return CenterChangeRequest()
    ..mhtId = json['mht_id'] as String
    ..centerName = json['center_name'] as String
    ..startDate = json['start_date'] as String
    ..reason = json['reason'] as String
    ..status = json['status'] as String;
}

Map<String, dynamic> _$CenterChangeRequestToJson(
        CenterChangeRequest instance) =>
    <String, dynamic>{
      'mht_id': instance.mhtId,
      'center_name': instance.centerName,
      'start_date': instance.startDate,
      'reason': instance.reason,
      'status': instance.status,
    };
