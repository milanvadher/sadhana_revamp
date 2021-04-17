// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) {
  return Session()
    ..name = json['name'] as String
    ..date = json['session_date'] as String
    ..group = json['group_name'] as String
    ..dvdType = json['type'] as String
    ..dvdNo = json['number'] as int
    ..dvdPart = json['satsang_part'] as String
    ..remark = json['remark'] as String
    ..sessionType = json['session_type'] as String
    ..attendance = (json['attendance'] as List)
            ?.map((e) => e == null
                ? null
                : Attendance.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [];
}

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'name': instance.name,
      'session_date': instance.date,
      'group_name': instance.group,
      'type': instance.dvdType,
      'number': instance.dvdNo,
      'satsang_part': instance.dvdPart,
      'remark': instance.remark,
      'session_type': instance.sessionType,
      'attendance': instance.attendance?.map((e) => e?.toJson())?.toList(),
    };

Attendance _$AttendanceFromJson(Map<String, dynamic> json) {
  return Attendance()
    ..mhtId = json['mht_id'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..isPresent = AppUtils.convertToIntToBool(json['is_present'] as int)
    ..reason = json['absent_reason'] as String;
}

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'mht_id': instance.mhtId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_present': AppUtils.convertBoolToInt(instance.isPresent),
      'absent_reason': instance.reason,
    };
