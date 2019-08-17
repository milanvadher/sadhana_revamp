// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationRequest _$RegistrationRequestFromJson(Map<String, dynamic> json) {
  return RegistrationRequest()
    ..mhtId = json['mht_id'] as String
    ..mobile = json['mobile'] as String
    ..center = json['center'] as String
    ..emailId = json['email'] as String
    ..firstName = json['first_name'] as String
    ..lastName = json['last_name'] as String
    ..requestSource = json['request_source'] as String
    ..iCardPhoto = json['icard_photo'] as String;
}

Map<String, dynamic> _$RegistrationRequestToJson(
        RegistrationRequest instance) =>
    <String, dynamic>{
      'mht_id': instance.mhtId,
      'mobile': instance.mobile,
      'center': instance.center,
      'email': instance.emailId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'request_source': instance.requestSource,
      'icard_photo': instance.iCardPhoto,
    };
