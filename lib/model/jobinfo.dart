import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/utils/apputils.dart';
part 'jobinfo.g.dart';

@JsonSerializable()
class JobInfo {
  JobInfo();
  @JsonKey(name: 'occupation')
  String occupation;
  @JsonKey(name: 'job_start_date' , fromJson: AppUtils.convertDateStrToDate, toJson: AppUtils.convertDateToDateStr)
  DateTime jobStartDate;
  @JsonKey(name: 'company_name')
  String companyName;
  @JsonKey(name: 'work_city')
  String workCity;
  factory JobInfo.fromJson(Map<String, dynamic> json) => _$JobInfoFromJson(json);
  Map<String, dynamic> toJson() => _$JobInfoToJson(this);
}