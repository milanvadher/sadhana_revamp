import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/utils/apputils.dart';

part "center.g.dart";
@JsonSerializable()
class Center {

  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'center_name')
  String title;
  Center();
  factory Center.fromJson(Map<String, dynamic> json) => _$CenterFromJson(json);
  Map<String, dynamic> toJson() => _$CenterToJson(this);

  static Center fromJsonFun(Map<String, dynamic> json) => Center.fromJson(json);
  static List<Center> fromJsonList(dynamic json) {
    return AppUtils.fromJsonList<Center>(json, Center.fromJsonFun);
  }
}