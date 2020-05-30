import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';

import 'jobinfo.dart';

part "center_change_request.g.dart";

@JsonSerializable()
class CenterChangeRequest {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'mht_id')
  String mhtId;
  @JsonKey(name: 'center_name')
  String centerName;
  @JsonKey(name: 'start_date', fromJson: AppUtils.convertDateStrToDate, toJson: AppUtils.convertDateToDateStr)
  DateTime startDate;
  @JsonKey(name: 'reason')
  String reason;
  @JsonKey(name: 'status')
  String status;
  @JsonKey(name: 'reason_description')
  String description;
  @JsonKey(name: 'occupation')
  String occupation;
  @JsonKey(name: 'company_name')
  String companyName;
  @JsonKey(name: 'work_city')
  String workCity;
  @JsonKey(ignore: true)
  JobInfo jobInfo = JobInfo();

  /*JobInfo getJobInfo() {
    if (AppUtils.equalsIgnoreCase(reason, WSConstant.JOB_CHANGE)) {
      jobInfo = JobInfo.fromCenterChangeRequest(this);
    }
    return jobInfo;
  }

  void setJobInfo(JobInfo inputJobInfo) {
    jobInfo = inputJobInfo;
    String jsondesc = json.encode(jobInfo.toJson());
    description = jsondesc;
  }*/

  CenterChangeRequest();

  factory CenterChangeRequest.fromJson(Map<String, dynamic> json) {
    CenterChangeRequest centerChangeRequest = _$CenterChangeRequestFromJson(json);
    if (AppUtils.equalsIgnoreCase(centerChangeRequest.reason, WSConstant.JOB_CHANGE)) {
      centerChangeRequest.jobInfo = JobInfo.fromCenterChangeRequest(centerChangeRequest);
    }
    return centerChangeRequest;
  }

  Map<String, dynamic> toJson() {
    if (AppUtils.equalsIgnoreCase(reason, WSConstant.JOB_CHANGE)) {
      jobInfo.toCenterChangeRequest(this);
    }
    return _$CenterChangeRequestToJson(this);
  }
}
