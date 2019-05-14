import 'dart:ui';

import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/model/activity.dart';

class Sadhana {
  static final String tableSadhana = 'Sadhana';
  static final String columnId = '_id';
  static final String columnIndex = 'index';
  static final String columnName = 'name';
  static final String columnDescription = 'description';
  static final String columnType = 'type';
  static final String columnIsPreloaded = 'is_preloaded';
  static final String columnDColor = 'd_color';
  static final String columnLColor = 'l_color';
  static final String columnReminderTime = 'reminder_time';
  static final String columnReminderDays = 'reminder_days';

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
  Map<DateTime,Activity> sadhanaData = new Map();
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
    this.sadhanaData,
  })  : assert(id != null),
        assert(sadhanaName != null),
        assert(sadhanaType != null),
        assert(dColor != null),
        assert(lColor != null);

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
