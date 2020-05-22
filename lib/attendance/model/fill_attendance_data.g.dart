// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fill_attendance_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FillAttendanceData _$FillAttendanceDataFromJson(Map<String, dynamic> json) {
  return FillAttendanceData()
    ..groupName = json['group_name'] as String
    ..groupTitle = json['group_title'] as String
    ..centerName = json['center_name'] as String
    ..centerTitle = json['center_title'] as String
    ..attendanceType = FillAttendanceData.convertToStrTypeToEnum(
        json['attendance_type'] as String)
    ..eventName = json['event_name'] as String;
}

Map<String, dynamic> _$FillAttendanceDataToJson(FillAttendanceData instance) =>
    <String, dynamic>{
      'group_name': instance.groupName,
      'group_title': instance.groupTitle,
      'center_name': instance.centerName,
      'center_title': instance.centerTitle,
      'attendance_type':
          FillAttendanceData.convertEnumToStr(instance.attendanceType),
      'event_name': instance.eventName,
    };
