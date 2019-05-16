abstract class Entity {

  static final String columnId = '_id';
  int id;
  setID(int id) {
    this.id = id;
  }
  int getID() {
    return id;
  }
  Entity fromMap(Map<String, dynamic> map);
  toMap();
}

