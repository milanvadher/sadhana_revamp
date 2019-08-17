import 'package:json_annotation/json_annotation.dart';

part "registration_request.g.dart";
@JsonSerializable()
class RegistrationRequest {

  @JsonKey(name: 'mht_id')
  String mhtId;
  @JsonKey(name: 'mobile')
  String mobile;
  @JsonKey(name: 'center')
  String center;
  @JsonKey(name: 'email')
  String emailId;
  @JsonKey(name: 'first_name')
  String firstName;
  @JsonKey(name: 'last_name')
  String lastName;
  @JsonKey(name: 'request_source')
  String requestSource;
  @JsonKey(name: 'icard_photo')
  String iCardPhoto;

  RegistrationRequest();

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) => _$RegistrationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegistrationRequestToJson(this);



}