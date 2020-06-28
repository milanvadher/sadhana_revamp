// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccess _$UserAccessFromJson(Map<String, dynamic> json) {
  return UserAccess()
    ..fillAttendance = json['fill_attendance'] as bool
    ..showMyAttendance =
        AppUtils.convertToIntToBool(json['show_my_attendance'] as int)
    ..fillEventAttendance =
        AppUtils.convertToIntToBool(json['fill_event_attendance'] as int)
    ..fillAttendanceData = json['fill_attendance_data'] == null
        ? null
        : FillAttendanceData.fromJson(
            json['fill_attendance_data'] as Map<String, dynamic>)
    ..attendanceEditableDays = json['attendance_editable_days'] as int ?? 60
    ..myAttendanceType = json['my_event_type'] as String;
}

Map<String, dynamic> _$UserAccessToJson(UserAccess instance) =>
    <String, dynamic>{
      'fill_attendance': instance.fillAttendance,
      'show_my_attendance':
          AppUtils.convertBoolToInt(instance.showMyAttendance),
      'fill_event_attendance':
          AppUtils.convertBoolToInt(instance.fillEventAttendance),
      'fill_attendance_data': instance.fillAttendanceData?.toJson(),
      'attendance_editable_days': instance.attendanceEditableDays,
      'my_event_type': instance.myAttendanceType,
    };
