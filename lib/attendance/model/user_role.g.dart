// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) {
  return UserRole(
      mhtId: json['mht_id'] as String,
      groupName: json['group_name'] as String,
      role: json['role'] as String);
}

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'mht_id': instance.mhtId,
      'group_name': instance.groupName,
      'role': instance.role
    };
