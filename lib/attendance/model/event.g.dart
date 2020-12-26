// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event()
    ..eventName = json['event_name'] as String
    ..name = json['name'] as String
    ..startDate = json['start_date'] as String
    ..endDate = json['end_date'] as String
    ..isEditable = json['is_editable'] as bool
    ..isAttendanceTaken = json['is_attendance_taken'] as bool
    ..sessions = (json['sessions'] as List)
        ?.map((e) =>
            e == null ? null : Session.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'event_name': instance.eventName,
      'name': instance.name,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'is_editable': instance.isEditable,
      'is_attendance_taken': instance.isAttendanceTaken,
      'sessions': instance.sessions?.map((e) => e?.toJson())?.toList(),
    };
