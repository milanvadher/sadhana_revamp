
import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/attendance/model/fill_attendance_data.dart';
import 'package:sadhana/utils/apputils.dart';

part "user_access.g.dart";

@JsonSerializable()
class UserAccess {
  @JsonKey(name: 'fill_attendance')
  bool fillAttendance;
  @JsonKey(name: 'show_my_attendance', fromJson: AppUtils.convertToIntToBool, toJson: AppUtils.convertBoolToInt)
  bool showMyAttendance;
  @JsonKey(name: 'fill_event_attendance', fromJson: AppUtils.convertToIntToBool, toJson: AppUtils.convertBoolToInt)
  bool fillEventAttendance;
  @JsonKey(name: 'fill_attendance_data')
  FillAttendanceData fillAttendanceData;
  @JsonKey(name: 'attendance_editable_days')
  int attendanceEditableDays = 60;
  @JsonKey(name: 'mba_event_type')
  String myAttendanceType;

  UserAccess();

  bool get isAttendanceCord => fillAttendance;
  factory UserAccess.fromJson(Map<String, dynamic> json) => _$UserAccessFromJson(json);
  Map<String, dynamic> toJson() => _$UserAccessToJson(this);
}

