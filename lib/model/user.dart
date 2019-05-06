class User {
  final String tableUser = 'User';
  final String columnId = '_id';
  final String columnFirstName = 'first_name';
  final String columnLastName = 'last_name';
  final String columnMhtId = 'mht_id';
  final String columnCenter = 'center';

  int id;
  String firstName;
  String lastName;
  int mhtId;
  String center;

  User({this.id, this.firstName, this.lastName, this.mhtId, this.center});

  User.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    firstName = map[columnFirstName];
    lastName = map[columnLastName];
    mhtId = map[columnMhtId];
    center = map[columnCenter];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnMhtId: mhtId,
      columnFirstName: firstName,
      columnLastName: lastName,
      columnCenter: center,
      columnId: id
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
