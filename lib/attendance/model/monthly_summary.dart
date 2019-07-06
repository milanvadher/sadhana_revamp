import 'package:json_annotation/json_annotation.dart';
part 'monthly_summary.g.dart';

@JsonSerializable()
class MonthlySummary {
  @JsonKey(name: 'mht_id')
  String mhtId;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'totalattendancedates')
  int totalattendancedates;
  @JsonKey(name: 'presentdates')
  int presentdates;
  @JsonKey(name: 'lessattendancereason')
  String lessattendancereason;

  MonthlySummary(
      {String mhtId,
      String name,
      int totalattendancedates,
      int presentdates,
      String lessattendancereason});

  factory MonthlySummary.fromJson(Map<String, dynamic> json) =>
      _$MontlySummaryFromJson(json);
      
  Map<String, dynamic> toJson() => _$MontlySummaryToJson(this);
  static List<MonthlySummary> fromJsonList(dynamic jsonList) {
    return (jsonList as List)
        ?.map((e) => e == null
            ? null
            : MonthlySummary.fromJson(e as Map<String, dynamic>))
        ?.toList();
  }
}
