import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/utils/apputils.dart';

part "mba_center.g.dart";
@JsonSerializable()
class MBACenter {

  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'center_name')
  String title;
  MBACenter();
  factory MBACenter.fromJson(Map<String, dynamic> json) => _$MBACenterFromJson(json);
  Map<String, dynamic> toJson() => _$MBACenterToJson(this);

  static MBACenter fromJsonFun(Map<String, dynamic> json) => MBACenter.fromJson(json);
  static List<MBACenter> fromJsonList(dynamic json) {
    return AppUtils.fromJsonList<MBACenter>(json, MBACenter.fromJsonFun);
  }
}