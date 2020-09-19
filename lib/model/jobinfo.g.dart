// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobinfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobInfo _$JobInfoFromJson(Map<String, dynamic> json) {
  return JobInfo()
    ..occupation = json['occupation'] as String ?? 'Job'
    ..jobStartDate =
        AppUtils.convertDateStrToDate(json['job_start_date'] as String)
    ..companyName = json['company_name'] as String
    ..workCity = json['work_city'] as String;
}

Map<String, dynamic> _$JobInfoToJson(JobInfo instance) => <String, dynamic>{
      'occupation': instance.occupation,
      'job_start_date': AppUtils.convertDateToDateStr(instance.jobStartDate),
      'company_name': instance.companyName,
      'work_city': instance.workCity,
    };
