import 'package:json_annotation/json_annotation.dart';
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

  static List<MBA> fromJsonList(List<dynamic> json) {
    List<MBA> attendanceMBAList;
    if (json != null) {
      attendanceMBAList = new List<MBA>();
      json.forEach((v) {
        attendanceMBAList.add(new MBA.fromJson(v));
      });
    }
    return attendanceMBAList;
  }
}
