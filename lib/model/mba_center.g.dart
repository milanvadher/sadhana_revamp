// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mba_center.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MBACenter _$MBACenterFromJson(Map<String, dynamic> json) {
  return MBACenter()
    ..name = json['name'] as String
    ..title = json['center_name'] as String;
}

Map<String, dynamic> _$MBACenterToJson(MBACenter instance) => <String, dynamic>{
      'name': instance.name,
      'center_name': instance.title,
    };
