import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';

part "mba_attendance.g.dart";

@JsonSerializable()
class MBAAttendance extends EventInterface{
  
  @JsonKey(name: 'session_date')
  String sessionDate;

  DateTime get attendanceDate => sessionDate != null ? WSConstant.wsDateFormat.parse(sessionDate) : null;

  @JsonKey(name: 'is_present', fromJson: _isPresentFromJson, toJson: _isPresentToJson)
  bool isPresent;

  MBAAttendance();

  MBAAttendance.name(this.sessionDate, this.isPresent);

  static bool _isPresentFromJson(int isPresent) => isPresent != null ? isPresent > 0 ? true : false : false;
  static int _isPresentToJson(bool isPresent) => isPresent ? 1 : 0;

  factory MBAAttendance.fromJson(Map<String, dynamic> json) => _$MBAAttendanceFromJson(json);
  Map<String, dynamic> toJson() => _$MBAAttendanceToJson(this);

  static MBAAttendance fromJsonFun(Map<String, dynamic> json) => MBAAttendance.fromJson(json);
  static List<MBAAttendance> fromJsonList(dynamic json) {
    return AppUtils.fromJsonList<MBAAttendance>(json, MBAAttendance.fromJsonFun);
  }

  @override
  String toString() {
    return 'MBAAttendance{sessionDate: $sessionDate, isPresent: $isPresent}';
  }

  @override
  DateTime getDate() {
    return WSConstant.wsDateFormat.parse(sessionDate);
  }

  @override
  Widget getDot() {
    throw UnimplementedError();
  }

  @override
  Widget getIcon() {
    return Container();
  }

  @override
  String getTitle() {
    return "Attendance";
  }
}