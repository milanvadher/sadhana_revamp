// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceSummary _$AttendanceSummaryFromJson(Map<String, dynamic> json) {
  return AttendanceSummary()
    ..mhtId = json['mht_id'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..totalAttendanceDates = json['totalattendancedates'] as int
    ..presentDates = json['presentdates'] as int
    ..lessAttendanceReason = json['lessattendancereason'] as String;
}

Map<String, dynamic> _$AttendanceSummaryToJson(AttendanceSummary instance) =>
    <String, dynamic>{
      'mht_id': instance.mhtId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'totalattendancedates': instance.totalAttendanceDates,
      'presentdates': instance.presentDates,
      'lessattendancereason': instance.lessAttendanceReason
    };
