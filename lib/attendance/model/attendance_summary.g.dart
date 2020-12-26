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
    ..date = json['date'] as String
    ..totalAttendanceDates = json['total_session_for_mht'] as int
    ..presentDates = json['present_dates'] as int
    ..lessAttendanceReason = json['less_attendance_reason'] as String;
}

Map<String, dynamic> _$AttendanceSummaryToJson(AttendanceSummary instance) =>
    <String, dynamic>{
      'mht_id': instance.mhtId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'date': instance.date,
      'total_session_for_mht': instance.totalAttendanceDates,
      'present_dates': instance.presentDates,
      'less_attendance_reason': instance.lessAttendanceReason,
    };
