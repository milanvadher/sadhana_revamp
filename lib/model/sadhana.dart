import 'dart:ui';

import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/entity.dart';

class Sadhana extends Entity {
  static final String tableSadhana = 'Sadhana';
  static final String columnIndex = 'sadhana_index';
  static final String columnName = 'name';
  static final String columnDescription = 'description';
  static final String columnType = 'type';
  static final String columnIsPreloaded = 'is_preloaded';
  static final String columnDColor = 'd_color';
  static final String columnLColor = 'l_color';
  static final String columnReminderTime = 'reminder_time';
  static final String columnReminderDays = 'reminder_days';


  String name;
  int index;
  String description;
  SadhanaType type;
  bool isPreloaded;
  Color dColor;
  Color lColor;
  List<Color> _colors;
  DateTime reminderTime;
  String reminderDays;
  Map<int,Activity> activitiesByDate = new Map();
  Sadhana({
    id,
    this.name,
    this.index,
    this.description,
    this.type,
    this.isPreloaded = false,
    this.dColor,
    this.lColor,
    this.reminderTime,
    this.reminderDays,
    sadhanaData,
  })  : assert(name != null),
        assert(description != null),
        assert(type != null),
        assert(dColor != null),
        assert(lColor != null),
        this.activitiesByDate = sadhanaData ?? new Map()
  ;

  Sadhana.clone(Sadhana original) {
    this.id = original.id;
    this.name = original.name;
    this.index = original.index;
    this.description = original.description;
    this.type = original.type;
    this.isPreloaded = original.isPreloaded;
    this.dColor = original.dColor;
    this.lColor = original.lColor;
    this.reminderTime = original.reminderTime;
    this.reminderDays = original.reminderDays;
    this.activitiesByDate = original.activitiesByDate;
  }

  convertForJson(dynamic source, dynamic dest) {
    dest.id = source.id;
    dest.name = source.name;
    dest.index = source.index;
    dest.description = source.description;
    dest.type = source.type;
    dest.isPreloaded = source.isPreloaded;
    dest.dColor = source.dColor;
    dest.lColor = source.lColor;
    dest.reminderTime = source.reminderTime;
    dest.reminderDays = source.reminderDays;
  }

  Sadhana.fromJson(Map<String, dynamic> json) {
    convertForJson(json, this);
  }
  List<Color> getColors() {
      return [lColor,dColor];
  }

  setColors(List<Color> colors) {
      this.lColor = colors[0];
      this.dColor = colors[1];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    convertForJson(this, data);
    return data;
  }

  Sadhana fromMap(Map<String, dynamic> map) {
    id = map[Entity.columnId];
    name = map[columnName];
    index = map[columnIndex];
    description = map[columnDescription];
    type = map[columnType] == 1 ? SadhanaType.NUMBER : SadhanaType.BOOLEAN;
    isPreloaded = map[columnIsPreloaded] == 1 ? true : false;
    dColor = Color(map[columnDColor]);
    lColor = Color(map[columnLColor]);
    reminderTime = map[columnReminderTime] != null ? DateTime.fromMillisecondsSinceEpoch(map[columnReminderTime]) : null;
    reminderDays = map[columnReminderDays];
    activitiesByDate = new Map();
    return this;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnIndex: index,
      columnDescription: description,
      columnType: type.index,
      columnIsPreloaded: isPreloaded ? 1 : 0,
      columnDColor: dColor.value,
      columnLColor: lColor.value,
      columnReminderDays: reminderDays,
      columnReminderTime: reminderTime != null ? reminderTime.millisecondsSinceEpoch : null,
      Entity.columnId: id
    };
    if (id != null) {
      map[Entity.columnId] = id;
    }
    return map;
  }

}
