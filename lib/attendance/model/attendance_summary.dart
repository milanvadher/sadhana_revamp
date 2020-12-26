import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:intl/intl.dart';
part 'attendance_summary.g.dart';

@JsonSerializable()
class AttendanceSummary {
  @JsonKey(name: 'mht_id')
  String mhtId;

  @JsonKey(name: 'first_name')
  String firstName;

  @JsonKey(name: 'last_name')
  String lastName;

  @JsonKey(name: 'date')
  String date;

  DateTime get dateTime =>  date != null ? WSConstant.wsDateFormat.parse(date) : null;

  @JsonKey(ignore: true)
  String get name => date != null ? new DateFormat(Constant.APP_MONTH_YEAR_FORMAT).format(dateTime) : '$firstName $lastName';

  @JsonKey(name: 'total_session_for_mht')
  int totalAttendanceDates;

  @JsonKey(name: 'present_dates')
  int presentDates;

  @JsonKey(name: 'less_attendance_reason')
  String lessAttendanceReason;

  @JsonKey(ignore: true)
  bool showRemarks = false;

  int get percentage => ((presentDates / totalAttendanceDates) * 100).toInt();

  AttendanceSummary();

  @override
  String toString() {
    return 'AttendanceSummary{mhtId: $mhtId, name: $name, totalattendancedates: $totalAttendanceDates, presentdates: $presentDates, lessattendancereason: $lessAttendanceReason}';
  }

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) => _$AttendanceSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceSummaryToJson(this);

  static fromJsonFun(Map<String, dynamic> json) => AttendanceSummary.fromJson(json);
  static List<AttendanceSummary> fromJsonList(dynamic jsonList) {
    return AppUtils.fromJsonList<AttendanceSummary>(jsonList, fromJsonFun);
  }
  static toJsonList(List<AttendanceSummary> summary) {
    return summary?.map((e) => e?.toJson())?.toList();
  }

}
