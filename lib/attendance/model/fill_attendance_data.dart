import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';

part "fill_attendance_data.g.dart";

@JsonSerializable()
class FillAttendanceData {
  @JsonKey(name: 'group_name')
  String groupName;
  @JsonKey(name: 'group_title')
  String groupTitle;

  @JsonKey(name: 'center_name')
  String centerName;
  @JsonKey(name: 'center_title')
  String centerTitle;
  @JsonKey(name: 'attendance_type', fromJson: convertToStrTypeToEnum, toJson: convertEnumToStr)
  AttendanceType attendanceType;
  @JsonKey(name: 'event_name')
  String eventName;

  bool get isCenterType => AttendanceType.CENTER == attendanceType;
  bool get isGDType => AttendanceType.GD == attendanceType;
  bool get isEventType => AttendanceType.EVENT == attendanceType;
  FillAttendanceData();

  factory FillAttendanceData.fromJson(Map<String, dynamic> json) => _$FillAttendanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$FillAttendanceDataToJson(this);

  static AttendanceType convertToStrTypeToEnum(String input, {AttendanceType defaultValue}) {
    if (input == null) {
      return defaultValue;
    } else {
      if (AppUtils.equalsIgnoreCase(input, WSConstant.attendanceType_Center))
        return AttendanceType.CENTER;
      else if (AppUtils.equalsIgnoreCase(input, WSConstant.attendanceType_GD))
        return AttendanceType.GD;
      else if (AppUtils.equalsIgnoreCase(input, WSConstant.attendanceType_Event)) return AttendanceType.EVENT;
    }
    return null;
  }

  static String convertEnumToStr(AttendanceType input, {String defaultValue}) {
    if (input == null) {
      return defaultValue;
    } else {
      if (input == AttendanceType.CENTER)
        return WSConstant.attendanceType_Center;
      else if (input == AttendanceType.GD)
        return WSConstant.attendanceType_GD;
      else if (input == AttendanceType.EVENT) return WSConstant.attendanceType_Event;
    }
    return null;
  }
}

enum AttendanceType { CENTER, GD, EVENT }
