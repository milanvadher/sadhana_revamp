abstract class Entity {

  static final String columnId = '_id';
  int id;
  String getColumnID() {
    return columnId;
  }
  setID(int id) {
    this.id = id;
  }
  int getID() {
    return id;
  }
  fromMap(Map<String, dynamic> map);
  toMap();
}

