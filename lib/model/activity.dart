class Activity {
  static final String tableActivity = 'Activity';
  static final String columnId = '_id';
  static final String columnSadhanaId = 'sadhana_id';
  static final String columnSadhanaDate = 'sadhana_date';
  static final String columnSadhanaActivityDate = 'sadhana_activity_date';
  static final String columnSadhanaValue = 'sadhana_value';
  static final String columnIsSynced = 'is_synced';
  static final String columnRemarks = 'remarks';

  int id;
  int sadhanaId;
  DateTime sadhanaDate;
  DateTime sadhanaActivityDate;
  int sadhanaValue;
  int isSynced;
  String remarks;

  Activity({
    this.id,
    this.sadhanaId,
    this.sadhanaDate,
    this.sadhanaActivityDate,
    this.sadhanaValue,
    this.isSynced,
    this.remarks,
  });

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

  Activity.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    sadhanaId = map[columnSadhanaId];
    sadhanaDate = map[columnSadhanaDate];
    sadhanaActivityDate = map[columnSadhanaActivityDate];
    sadhanaValue = map[columnSadhanaValue];
    isSynced = map[columnIsSynced];
    remarks = map[columnRemarks];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnSadhanaId: sadhanaId,
      columnSadhanaDate: sadhanaDate,
      columnSadhanaActivityDate: sadhanaActivityDate,
      columnSadhanaValue: sadhanaValue,
      columnIsSynced: isSynced,
      columnRemarks: remarks
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

}
