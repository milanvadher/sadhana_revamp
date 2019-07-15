// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mba_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MBAAttendance _$MBAAttendanceFromJson(Map<String, dynamic> json) {
  return MBAAttendance()
    ..sessionDate = json['session_date'] as String
    ..isPresent = MBAAttendance._isPresentFromJson(json['is_present'] as int);
}

Map<String, dynamic> _$MBAAttendanceToJson(MBAAttendance instance) =>
    <String, dynamic>{
      'session_date': instance.sessionDate,
      'is_present': MBAAttendance._isPresentToJson(instance.isPresent)
    };
