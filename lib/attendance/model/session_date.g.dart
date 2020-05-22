// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionDate _$SessionDateFromJson(Map<String, dynamic> json) {
  return SessionDate()
    ..name = json['name'] as String
    ..date = json['session_date'] as String;
}

Map<String, dynamic> _$SessionDateToJson(SessionDate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'session_date': instance.date,
    };
