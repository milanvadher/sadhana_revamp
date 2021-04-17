import 'dart:ui';

import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/entity.dart';
import 'package:sadhana/model/sadhana_statistics.dart';
import 'package:sadhana/utils/apputils.dart';

class Sadhana extends Entity {
  static final String tableSadhana = 'Sadhana';
  static final String columnIndex = 'sadhana_index';
  static final String columnName = 'name';
  static final String columnServerSName = 'server_sname';
  static final String columnDescription = 'description';
  static final String columnType = 'type';
  static final String columnTargetValue = 'targetvalue';
  static final String columnIsPreloaded = 'is_preloaded';
  static final String columnDColor = 'd_color';
  static final String columnLColor = 'l_color';
  static final String columnReminderTime = 'reminder_time';
  static final String columnReminderDays = 'reminder_days';

  static final createSadhanaTable = ''' create table ${Sadhana.tableSadhana} ( 
  ${Entity.columnId} integer primary key autoincrement, 
  ${Sadhana.columnName} text not null ON CONFLICT REPLACE,
  ${Sadhana.columnServerSName} text,
  ${Sadhana.columnDescription} text,
  ${Sadhana.columnIndex} integer not null,
  ${Sadhana.columnLColor} integer not null,
  ${Sadhana.columnDColor} integer not null,
  ${Sadhana.columnType} integer not null,
  ${Sadhana.columnTargetValue} integer not null,
  ${Sadhana.columnIsPreloaded} boolean,
  ${Sadhana.columnReminderTime} date,
  ${Sadhana.columnReminderDays} text)
''';

  String sadhanaName;
  String serverSName;
  int index;
  String description;
  SadhanaType type;
  int targetValue = 1;
  bool isPreloaded = false;
  Color dColor;
  Color lColor;
  List<Color> _colors;
  DateTime reminderTime;
  String reminderDays;
  Map<String, Activity> activitiesByDate = new Map();
  bool isLoadedAllActivity = false;
  bool get isNumeric => type == SadhanaType.NUMBER;

  bool isActivityDone(Activity activity) {
    if (activity.sadhanaValue > 0) {
      bool isDone = true;
      if (isNumeric && activity.sadhanaValue < targetValue)
        isDone = false;
      return isDone;
    }
    return false;
  }

  SadhanaStatistics statistics = SadhanaStatistics();
  Sadhana({
    id,
    this.sadhanaName,
    this.index,
    this.description,
    this.type,
    this.targetValue = 1,
    this.isPreloaded = false,
    this.dColor,
    this.lColor,
    this.reminderTime,
    this.reminderDays,
    sadhanaData,
  })  : assert(sadhanaName != null),
        assert(type != null),
        assert(dColor != null),
        assert(lColor != null),
        this.activitiesByDate = sadhanaData ?? new Map();

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
    targetValue = map[columnTargetValue]?? 1;
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
      columnTargetValue: targetValue?? 1,
      columnIsPreloaded: isPreloaded == null ? 0 : isPreloaded,
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
    targetValue = json['target_value']?? 1;
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
    data['target_value'] = this.targetValue?? 1;
    return data;
  }
}
