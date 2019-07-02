import 'package:json_annotation/json_annotation.dart';
part "user_role.g.dart";

@JsonSerializable()
class UserRole {
  @JsonKey(name: 'mht_id')
  String mhtId;
  @JsonKey(name: 'group_name')
  String groupName;
  @JsonKey(name: 'role')
  String role;

  UserRole({this.mhtId, this.groupName, this.role});
  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);

}