import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';

part "session.g.dart";

@JsonSerializable()
class Session {
  @JsonKey(name: 'date')
  String date;
  @JsonKey(name: 'group')
  String group;
  @JsonKey(name: 'dvdtype')
  String dvdType;
  @JsonKey(name: 'dvdno')
  int dvdNo;
  @JsonKey(name: 'dvdpart')
  int dvdPart;
  @JsonKey(name: 'remark')
  String remark;

  DateTime get dateTime =>  date != null ? WSConstant.wsDateFormat.parse(date) : null;

  @JsonKey(name: 'attendance')
  List<Attendance> attendance;

  Session({this.date, this.group, this.dvdType, this.dvdNo, this.dvdPart, this.remark, this.attendance});
  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  Session.fromAttendanceList(String date, List<Attendance> attendances) {
    this.date = date;
    this.attendance = attendances;
  }

  @override
  String toString() {
    return 'Session{date: $date, group: $group, dvdType: $dvdType, dvdNo: $dvdNo, dvdPart: $dvdPart, remark: $remark, attendance: $attendance}';
  }

}

@JsonSerializable()
class Attendance {
  @JsonKey(name: 'mht_id')
  String mhtId;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'isPresent', fromJson: _isPresentFromJson, toJson: _isPresentToJson)
  bool isPresent;
  @JsonKey(name: 'absentreason')
  String absentReason;

  static bool _isPresentFromJson(int isPresent) => isPresent != null ? isPresent > 0 ? true : false : false;
  static int _isPresentToJson(bool isPresent) => isPresent ? 1 : 0;

  Attendance({this.mhtId, this.isPresent, this.absentReason});
  factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceToJson(this);

  static Attendance fromJsonFun(Map<String, dynamic> json) => Attendance.fromJson(json);
  static List<Attendance> fromJsonList(dynamic json) {
    return AppUtils.fromJsonList<Attendance>(json, Attendance.fromJsonFun);
  }

  @override
  String toString() {
    return 'Attendance{mhtId: $mhtId, name: $name, isPresent: $isPresent, absentReason: $absentReason}';
  }

}
