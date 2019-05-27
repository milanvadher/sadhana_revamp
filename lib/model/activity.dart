import 'package:sadhana/model/entity.dart';

class Activity extends Entity {
  static final String tableActivity = 'Activity';
  static final String columnSadhanaId = 'sadhana_id';
  static final String columnSadhanaDate = 'sadhana_date';
  static final String columnSadhanaActivityDate = 'sadhana_activity_date';
  static final String columnSadhanaValue = 'sadhana_value';
  static final String columnIsSynced = 'is_synced';
  static final String columnRemarks = 'remarks';

  static final createActivityTable = ''' create table ${Activity.tableActivity} ( 
  ${Entity.columnId} integer primary key autoincrement, 
  ${Activity.columnSadhanaId} integer not null,
  ${Activity.columnSadhanaDate} integer not null ON CONFLICT REPLACE,
  ${Activity.columnSadhanaActivityDate} integer not null,
  ${Activity.columnSadhanaValue} integer not null,
  ${Activity.columnIsSynced} integer,
  ${Activity.columnRemarks} text)
''';

  int sadhanaId;
  DateTime sadhanaDate;
  DateTime sadhanaActivityDate;
  int sadhanaValue;
  bool isSynced;
  String remarks;


  Activity({
    id,
    this.sadhanaId,
    this.sadhanaDate,
    sadhanaActivityDate,
    this.sadhanaValue,
    this.isSynced = false,
    this.remarks,
  }) : this.sadhanaActivityDate = sadhanaActivityDate ?? DateTime.now();

  convertForJson(dynamic source, dynamic dest) {
    dest.id = source.id;
    dest.sadhanaId = source.sadhanaId;
    dest.sadhanaDate = source.sadhanaDate;
    dest.sadhanaActivityDate = source.sadhanaActivityDate;
    dest.sadhanaValue = source.sadhanaValue;
    dest.isSynced = source.isSynced;
    dest.remarks = source.remarks;
  }

  Activity.fromJson(Map<String, dynamic> json) {
    convertForJson(json, this);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    convertForJson(this, data);
    return data;
  }

  Activity fromMap(Map<String, dynamic> map) {
    id = map[Entity.columnId];
    sadhanaId = map[columnSadhanaId];
    sadhanaDate = DateTime.fromMillisecondsSinceEpoch(map[columnSadhanaDate]);
    sadhanaActivityDate = DateTime.fromMillisecondsSinceEpoch(map[columnSadhanaActivityDate]);
    sadhanaValue = map[columnSadhanaValue];
    isSynced = map[columnIsSynced] == 0 ? false : true;
    remarks = map[columnRemarks];
    return this;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      Entity.columnId: id,
      columnSadhanaId: sadhanaId,
      columnSadhanaDate: sadhanaDate.millisecondsSinceEpoch,
      columnSadhanaActivityDate: sadhanaActivityDate != null ? sadhanaActivityDate.millisecondsSinceEpoch : null,
      columnSadhanaValue: sadhanaValue,
      columnIsSynced: isSynced ? 1 : 0,
      columnRemarks: remarks
    };
    if (id != null) {
      map[Entity.columnId] = id;
    }
    return map;
  }
  @override
  getTableName() {
    return tableActivity;
  }
}
