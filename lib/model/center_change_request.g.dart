// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'center_change_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CenterChangeRequest _$CenterChangeRequestFromJson(Map<String, dynamic> json) {
  return CenterChangeRequest()
    ..name = json['name'] as String
    ..mhtId = json['mht_id'] as String
    ..centerName = json['center_name'] as String
    ..startDate = AppUtils.convertDateStrToDate(json['start_date'] as String)
    ..reason = json['reason'] as String ?? 'Other'
    ..status = json['status'] as String
    ..description = json['reason_description'] as String
    ..occupation = json['occupation'] as String
    ..companyName = json['company_name'] as String
    ..workCity = json['work_city'] as String;
}

Map<String, dynamic> _$CenterChangeRequestToJson(
        CenterChangeRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mht_id': instance.mhtId,
      'center_name': instance.centerName,
      'start_date': AppUtils.convertDateToDateStr(instance.startDate),
      'reason': instance.reason,
      'status': instance.status,
      'reason_description': instance.description,
      'occupation': instance.occupation,
      'company_name': instance.companyName,
      'work_city': instance.workCity,
    };
