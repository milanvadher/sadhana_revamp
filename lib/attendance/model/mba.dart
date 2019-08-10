import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/utils/apputils.dart';
part "mba.g.dart";

@JsonSerializable()
class MBA {
  @JsonKey(name: 'mht_id')
  String mhtId;

  @JsonKey(name: 'name')
  String name;

  MBA({this.mhtId, this.name});

  factory MBA.fromJson(Map<String, dynamic> json) => _$MBAFromJson(json);
  Map<String, dynamic> toJson() => _$MBAToJson(this);

  static fromJsonFun(Map<String, dynamic> json) => MBA.fromJson(json);
  static List<MBA> fromJsonList(List<dynamic> json) {
    return AppUtils.fromJsonList<MBA>(json, fromJsonFun);
  }
}
