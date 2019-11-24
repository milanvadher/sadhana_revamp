import 'package:json_annotation/json_annotation.dart';

part "center_change_request.g.dart";

@JsonSerializable()
class CenterChangeRequest {

  
  @JsonKey(name: 'mht_id')
  String mhtId;
  @JsonKey(name: 'center_name')
  String centerName;
  @JsonKey(name: 'start_date')
  String startDate;
  @JsonKey(name: 'reason')
  String reason;
  @JsonKey(name: 'status')
  String status;

  CenterChangeRequest();

  factory CenterChangeRequest.fromJson(Map<String, dynamic> json) => _$CenterChangeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CenterChangeRequestToJson(this);



}