import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/utils/apputils.dart';

import 'jobinfo.dart';

part "center_change_request.g.dart";

@JsonSerializable()
class CenterChangeRequest {

  
  @JsonKey(name: 'mht_id')
  String mhtId;
  @JsonKey(name: 'center_name')
  String centerName;
  @JsonKey(name: 'start_date' , fromJson: AppUtils.convertDateStrToDate, toJson: AppUtils.convertDateToDateStr)
  DateTime startDate;
  @JsonKey(name: 'reason')
  String reason;
  @JsonKey(name: 'status')
  String status;
  @JsonKey(name: 'description')
  String description;

  JobInfo _jobInfo;

  JobInfo getJobInfo() {
    if(AppUtils.equalsIgnoreCase(reason, WSConstant.JOB_CHANGE)) {
      _jobInfo = JobInfo.fromJson(json.decode(description));
    }
    return _jobInfo;
  }

  void setJobInfo(JobInfo jobInfo) {
    _jobInfo = jobInfo;
    String jsondesc = json.encode(_jobInfo.toJson());
    description = jsondesc;
  }

  CenterChangeRequest();


  factory CenterChangeRequest.fromJson(Map<String, dynamic> json) => _$CenterChangeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CenterChangeRequestToJson(this);

}

