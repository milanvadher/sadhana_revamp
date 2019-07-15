import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';
part "user_role.g.dart";

@JsonSerializable()
class UserRole {
  @JsonKey(name: 'group_name')
  String groupName;
  @JsonKey(name: 'role')
  String role;
  @JsonKey(name: 'center')
  String center;
  @JsonKey(ignore: true)
  bool get isSimCityGroup => AppUtils.equalsIgnoreCase(center, WSConstant.center_Simcity);

  UserRole();

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);

}