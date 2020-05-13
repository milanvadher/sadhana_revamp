// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionDate _$SessionDateFromJson(Map<String, dynamic> json) {
  return SessionDate()
    ..name = json['session_name'] as String
    ..date = json['date'] as String;
}

Map<String, dynamic> _$SessionDateToJson(SessionDate instance) =>
    <String, dynamic>{
      'session_name': instance.name,
      'date': instance.date,
    };
