import 'dart:ui';
import 'package:sadhana/common.dart';

class Sadhana {
  final String tableSadhana = 'Sadhana';
  final String columnId = '_id';
  final String columnIndex = 'index';
  final String columnName = 'name';
  final String columnDescription = 'description';
  final String columnType = 'type';
  final String columnIsPreloaded = 'is_preloaded';
  final String columnDColor = 'd_color';
  final String columnLColor = 'l_color';
  final String columnReminderTime = 'reminder_time';
  final String columnReminderDays = 'reminder_days';

  int id;
  String sadhanaName;
  int sadhanaIndex;
  String sadhanaDescription;
  SadhanaType sadhanaType;
  bool isPreloaded;
  Color dColor;
  Color lColor;
  DateTime reminderTime;
  String reminderDays;

  Sadhana({
    this.id,
    this.sadhanaName,
    this.sadhanaIndex,
    this.sadhanaDescription,
    this.sadhanaType,
    this.isPreloaded,
    this.dColor,
    this.lColor,
    this.reminderTime,
    this.reminderDays,
  })  : assert(id != null),
        assert(sadhanaName != null),
        assert(sadhanaDescription != null),
        assert(sadhanaDescription != null),
        assert(sadhanaType != null),
        assert(isPreloaded != null),
        assert(dColor != null),
        assert(lColor != null),
        assert(reminderTime != null),
        assert(reminderDays != null);

  convertForJson(dynamic source, dynamic dest) {
    dest.id = source.id;
    dest.sadhanaName = source.sadhanaName;
    dest.sadhanaIndex = source.sadhanaIndex;
    dest.sadhanaDescription = source.sadhanaDescription;
    dest.sadhanaType = source.sadhanaType;
    dest.isPreloaded = source.isPreloaded;
    dest.dColor = source.dColor;
    dest.lColor = source.lColor;
    dest.reminderTime = source.reminderTime;
    dest.reminderDays = source.reminderDays;
  }

  Sadhana.fromJson(Map<String, dynamic> json) {
    convertForJson(json, this);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    convertForJson(this, data);
    return data;
  }

  Sadhana.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    sadhanaName = map[columnName];
    sadhanaIndex = map[columnIndex];
    sadhanaDescription = map[columnDescription];
    sadhanaType = map[columnType];
    isPreloaded = map[columnIsPreloaded];
    dColor = map[columnDColor];
    lColor = map[columnLColor];
    reminderTime = map[columnReminderTime];
    reminderDays = map[columnReminderDays];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: sadhanaName,
      columnIndex: sadhanaIndex,
      columnDescription: sadhanaDescription,
      columnType: sadhanaType,
      columnIsPreloaded: isPreloaded,
      columnDColor: dColor,
      columnLColor: lColor,
      columnReminderTime: reminderDays,
      columnReminderDays: reminderTime,
      columnId: id
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
