// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) {
  return Session(
      date: json['date'] as String,
      group: json['group'] as String,
      dvdType: json['dvdtype'] as String,
      dvdNo: json['dvd_no'] as int,
      dvdPart: json['dvd_part'] as int,
      remark: json['remark'] as String,
      attendance: (json['attendance'] as List)
          ?.map((e) =>
              e == null ? null : Attendance.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..sessionType = json['session_type'] as String;
}

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'date': instance.date,
      'group': instance.group,
      'dvdtype': instance.dvdType,
      'dvd_no': instance.dvdNo,
      'dvd_part': instance.dvdPart,
      'remark': instance.remark,
      'session_type': instance.sessionType,
      'attendance': instance.attendance?.map((e) => e?.toJson())?.toList()
    };

Attendance _$AttendanceFromJson(Map<String, dynamic> json) {
  return Attendance()
    ..mhtId = json['mht_id'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..isPresent = Attendance._isPresentFromJson(json['is_present'] as int)
    ..absentReason = json['absent_reason'] as String;
}

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'mht_id': instance.mhtId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_present': Attendance._isPresentToJson(instance.isPresent),
      'absent_reason': instance.absentReason
    };
