// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dvd_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DVDInfo _$DVDInfoFromJson(Map<String, dynamic> json) {
  return DVDInfo()
    ..date = json['date'] as String
    ..dvdType = json['type'] as String
    ..dvdNo = json['number'] as int
    ..name = json['name'] as String
    ..remark = json['remark'] as String;
}

Map<String, dynamic> _$DVDInfoToJson(DVDInfo instance) => <String, dynamic>{
      'date': instance.date,
      'type': instance.dvdType,
      'number': instance.dvdNo,
      'name': instance.name,
      'remark': instance.remark,
    };
