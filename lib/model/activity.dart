class Activity {
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

//  Activity.fromMap(Map<String, dynamic> map) {
//    id = map[columnId];
//    firstName = map[columnFirstName];
//    lastName = map[columnLastName];
//    mhtId = map[columnMhtId];
//    center = map[columnCenter];
//  }
//
//  Map<String, dynamic> toMap() {
//    var map = <String, dynamic>{
//      columnMhtId: mhtId,
//      columnFirstName: firstName,
//      columnLastName: lastName,
//      columnCenter: center,
//      columnId: id
//    };
//    if (id != null) {
//      map[columnId] = id;
//    }
//    return map;
//  }
}
