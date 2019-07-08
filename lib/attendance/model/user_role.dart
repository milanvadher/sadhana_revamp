import 'package:json_annotation/json_annotation.dart';
part "user_role.g.dart";

@JsonSerializable()
class UserRole {
  @JsonKey(name: 'group_name')
  String groupName;
  @JsonKey(name: 'role')
  String role;
  @JsonKey(name: 'is_simcity_group', defaultValue: true)
  bool isSimCityGroup;

  UserRole();

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);

}