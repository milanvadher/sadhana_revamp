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
      dvdNo: json['dvdno'] as int,
      dvdPart: json['dvdpart'] as int,
      remark: json['remark'] as String,
      attendance: (json['attendance'] as List)
          ?.map((e) =>
              e == null ? null : Attendance.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'date': instance.date,
      'group': instance.group,
      'dvdtype': instance.dvdType,
      'dvdno': instance.dvdNo,
      'dvdpart': instance.dvdPart,
      'remark': instance.remark,
      'attendance': instance.attendance
    };

Attendance _$AttendanceFromJson(Map<String, dynamic> json) {
  return Attendance(
      mhtId: json['mht_id'] as String,
      isPresent: Attendance._isPresentFromJson(json['isPresent'] as int),
      absentReason: json['absentreason'] as String)
    ..name = json['name'] as String;
}

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'mht_id': instance.mhtId,
      'name': instance.name,
      'isPresent': Attendance._isPresentToJson(instance.isPresent),
      'absentreason': instance.absentReason
    };
