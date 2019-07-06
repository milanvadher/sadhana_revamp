// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlySummary _$MontlySummaryFromJson(Map<String, dynamic> json) {
  return MonthlySummary(
      mhtId: json['mht_id'] as String,
      name: json['name'] as String,
      totalattendancedates: json['totalattendancedates'] as int,
      presentdates: json['presentdates'] as int,
      lessattendancereason: json['lessattendancereason'] as String);
}

Map<String, dynamic> _$MontlySummaryToJson(MonthlySummary instance) =>
    <String, dynamic>{
      'mht_id': instance.mhtId,
      'name': instance.name,
      'totalattendancedates': instance.totalattendancedates,
      'presentdates': instance.presentdates,
      'lessattendancereason': instance.lessattendancereason
    };
