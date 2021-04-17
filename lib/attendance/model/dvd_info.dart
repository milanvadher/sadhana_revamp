import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/utils/apputils.dart';

part 'dvd_info.g.dart';

@JsonSerializable()
class DVDInfo {
  @JsonKey(name: 'date')
  String date;
  @JsonKey(name: 'type')
  String dvdType;
  @JsonKey(name: 'number')
  int dvdNo;
  @JsonKey(name: 'name') // Primary Key of frappe doc
  String dvdPart;
  String remark;

  DVDInfo();

  DVDInfo.fromSession(Session session) {
    date = session.date;
    dvdType = session.dvdType;
    dvdNo = session.dvdNo;
    dvdPart = session.dvdPart;
    remark = session.remark;
  }

  static setSession(Session session, DVDInfo dvdInfo) {
    session.dvdType = dvdInfo.dvdType;
    session.dvdNo = dvdInfo.dvdNo;
    session.dvdPart = dvdInfo.dvdPart;
    session.remark = dvdInfo.remark;
  }

  factory DVDInfo.fromJson(Map<String, dynamic> json) =>
      _$DVDInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DVDInfoToJson(this);
  static DVDInfo fromJsonFun(Map<String, dynamic> json) =>
      DVDInfo.fromJson(json);
  static List<DVDInfo> fromJsonList(dynamic json) {
    return AppUtils.fromJsonList<DVDInfo>(
        json['dvd_part_details'], DVDInfo.fromJsonFun);
  }

  @override
  String toString() {
    return '$dvdType $dvdNo';
  }

  bool operator ==(dynamic other) =>
      other != null && other is DVDInfo && this.dvdPart == other.dvdPart;

  @override
  int get hashCode => super.hashCode;
}
