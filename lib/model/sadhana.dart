import 'dart:ui';

import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/entity.dart';
import 'package:sadhana/utils/apputils.dart';

class Sadhana extends Entity {
  static final String tableSadhana = 'Sadhana';
  static final String columnIndex = 'sadhana_index';
  static final String columnName = 'name';
  static final String columnServerSName = 'server_sname';
  static final String columnDescription = 'description';
  static final String columnType = 'type';
  static final String columnIsPreloaded = 'is_preloaded';
  static final String columnDColor = 'd_color';
  static final String columnLColor = 'l_color';
  static final String columnReminderTime = 'reminder_time';
  static final String columnReminderDays = 'reminder_days';

  static final createSadhanaTable = ''' create table ${Sadhana.tableSadhana} ( 
  ${Entity.columnId} integer primary key autoincrement, 
  ${Sadhana.columnName} text not null,
  ${Sadhana.columnServerSName} text,
  ${Sadhana.columnDescription} text,
  ${Sadhana.columnIndex} integer not null,
  ${Sadhana.columnLColor} integer not null,
  ${Sadhana.columnDColor} integer not null,
  ${Sadhana.columnType} integer not null,
  ${Sadhana.columnIsPreloaded} boolean,
  ${Sadhana.columnReminderTime} date,
  ${Sadhana.columnReminderDays} text)
''';

  String sadhanaName;
  String serverSName;
  int index;
  String description;
  SadhanaType type;
  bool isPreloaded;
  Color dColor;
  Color lColor;
  List<Color> _colors;
  DateTime reminderTime;
  String reminderDays;
  Map<int, Activity> activitiesByDate = new Map();

  Sadhana({
    id,
    this.sadhanaName,
    this.index,
    this.description,
    this.type,
    this.isPreloaded = false,
    this.dColor,
    this.lColor,
    this.reminderTime,
    this.reminderDays,
    sadhanaData,
  })  : assert(sadhanaName != null),
        assert(description != null),
        assert(type != null),
        assert(dColor != null),
        assert(lColor != null),
        this.activitiesByDate = sadhanaData ?? new Map();

  Sadhana.clone(Sadhana original) {
    this.id = original.id;
    this.sadhanaName = original.sadhanaName;
    this.serverSName = original.serverSName;
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

  List<Color> getColors() {
    return [lColor, dColor];
  }

  setColors(List<Color> colors) {
    this.lColor = colors[0];
    this.dColor = colors[1];
  }

  Sadhana fromMap(Map<String, dynamic> map) {
    id = map[Entity.columnId];
    sadhanaName = map[columnName];
    serverSName = map[columnServerSName];
    index = map[columnIndex];
    description = map[columnDescription];
    type = map[columnType] == SadhanaType.NUMBER.index ? SadhanaType.NUMBER : SadhanaType.BOOLEAN;
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
      columnName: sadhanaName,
      columnServerSName: serverSName,
      columnIndex: index,
      columnDescription: description,
      columnType: type.index,
      columnIsPreloaded: isPreloaded == null ? 0 : 1,
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

  Sadhana.fromJson(Map<String, dynamic> json) {
    serverSName = json['name'];
    String serverType = json['type'];
    type = SadhanaType.NUMBER.serverValue == serverType ? SadhanaType.NUMBER : SadhanaType.BOOLEAN;
    dColor = json['d_color'] != null ? AppUtils.hexToColor(json['d_color']) : Constant.colors[0][0];
    lColor = json['l_color'] != null ? AppUtils.hexToColor(json['l_color']) : Constant.colors[0][1];
    description = json['description'];
    sadhanaName = json['sadhana_name'];
    isPreloaded = json['isPreloaded'] ?? true;
    index = json['sadhana_index'] ?? 0;
  }

  static List<Sadhana> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Sadhana.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.serverSName;
    data['type'] = this.type.serverValue;
    data['d_color'] = this.dColor.value;
    data['l_color'] = this.lColor.value;
    data['description'] = this.description;
    data['sadhana_name'] = this.sadhanaName;
    data['sadhana_index'] = this.index;
    return data;
  }
}
