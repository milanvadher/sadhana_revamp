import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';

part "session.g.dart";

@JsonSerializable()
class Session {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'session_date')
  String date;
  @JsonKey(name: 'group_name')
  String group;
  @JsonKey(name: 'type')
  String dvdType;
  @JsonKey(name: 'number')
  int dvdNo;
  @JsonKey(name: 'satsang_part') // This is primary key in frappe docs
  String satsangPart;
  @JsonKey(name: 'remark')
  String remark;
  @JsonKey(name: 'session_type')
  String sessionType;

  DateTime get dateTime =>  date != null ? WSConstant.wsDateFormat.parse(date) : null;
  Session();
  @JsonKey(name: 'attendance' , defaultValue: [])
  List<Attendance> attendance;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  Session.fromAttendanceList(String group, String date, String sessionType, List<Attendance> attendances) {
    this.date = date;
    this.group = group;
    this.sessionType = sessionType;
    this.attendance = attendances;
  }

  @override
  String toString() {
    return 'Session{name: $name, date: $date, group: $group, dvdType: $dvdType, dvdNo: $dvdNo,  remark: $remark, sessionType: $sessionType, attendance: $attendance}';
  }
}

@JsonSerializable()
class Attendance {
  @JsonKey(name: 'mht_id')
  String mhtId;

  @JsonKey(name: 'first_name')
  String firstName;

  @JsonKey(name: 'last_name')
  String lastName;

  @JsonKey(ignore: true)
  String get name => '$firstName $lastName';

  @JsonKey(name: 'is_present', fromJson: AppUtils.convertToIntToBool, toJson: AppUtils.convertBoolToInt)
  bool isPresent;

  @JsonKey(name: 'absent_reason')
  String reason;

  Attendance();
  //static bool _isPresentFromJson(int isPresent) => AppUtils.convertToIntToBool(isPresent);
  //static int _isPresentToJson(bool isPresent) => AppUtils.convertBoolToInt(isPresent);


  factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceToJson(this);

  static Attendance fromJsonFun(Map<String, dynamic> json) => Attendance.fromJson(json);
  static List<Attendance> fromJsonList(dynamic json) {
    return AppUtils.fromJsonList<Attendance>(json, Attendance.fromJsonFun);
  }

  @override
  String toString() {
    return 'Attendance{mhtId: $mhtId, name: $name, isPresent: $isPresent, absentReason: $reason}';
  }
}
