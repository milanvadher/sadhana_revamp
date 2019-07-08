import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/utils/apputils.dart';
part 'attendance_summary.g.dart';

@JsonSerializable()
class AttendanceSummary {
  @JsonKey(name: 'mht_id')
  String mhtId;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'totalattendancedates')
  int totalAttendanceDates;
  @JsonKey(name: 'presentdates')
  int presentDates;
  @JsonKey(name: 'lessattendancereason')
  String lessAttendanceReason;

  @JsonKey(ignore: true)
  bool showRemarks = false;

  AttendanceSummary({this.mhtId, this.name, this.totalAttendanceDates, this.presentDates, this.lessAttendanceReason});

  @override
  String toString() {
    return 'MonthlySummary{mhtId: $mhtId, name: $name, totalattendancedates: $totalAttendanceDates, presentdates: $presentDates, lessattendancereason: $lessAttendanceReason}';
  }

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) => _$AttendanceSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceSummaryToJson(this);

  static fromJsonFun(Map<String, dynamic> json) => AttendanceSummary.fromJson(json);
  static List<AttendanceSummary> fromJsonList(dynamic jsonList) {
    return AppUtils.fromJsonList<AttendanceSummary>(jsonList, fromJsonFun);
  }
}
