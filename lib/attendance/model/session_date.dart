
import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';

part "session_date.g.dart";

@JsonSerializable()
class SessionDate {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'session_date')
  String date;
  SessionDate();
  DateTime get dateTime =>  date != null ? WSConstant.wsDateFormat.parse(date) : null;
  factory SessionDate.fromJson(Map<String, dynamic> json) => _$SessionDateFromJson(json);
  Map<String, dynamic> toJson() => _$SessionDateToJson(this);

  static SessionDate fromJsonFun(Map<String, dynamic> json) => SessionDate.fromJson(json);
  static List<SessionDate> fromJsonList(dynamic json) {
    return AppUtils.fromJsonList<SessionDate>(json, SessionDate.fromJsonFun);
  }
}