// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) {
  return UserRole()
    ..groupTitle = json['group_title'] as String
    ..groupName = json['group_name'] as String
    ..role = json['role'] as String
    ..center = json['center'] as String;
}

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'group_title': instance.groupTitle,
      'group_name': instance.groupName,
      'role': instance.role,
      'center': instance.center
    };
