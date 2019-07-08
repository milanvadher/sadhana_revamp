// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) {
  return UserRole()
    ..groupName = json['group_name'] as String
    ..role = json['role'] as String
    ..isSimCityGroup = json['is_simcity_group'] as bool ?? true;
}

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'group_name': instance.groupName,
      'role': instance.role,
      'is_simcity_group': instance.isSimCityGroup
    };
