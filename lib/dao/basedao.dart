import 'package:sadhana/model/entity.dart';
import 'package:sadhana/service/dbprovider.dart';

abstract class BaseDAO<T extends Entity> {
  DBProvider dbProvider = DBProvider.db;

  getTableName();

  T getDefaultInstance();

  Future<T> insert(T entity) async {
    final db = await dbProvider.database;
    entity.setID(await db.insert(getTableName(), entity.toMap()));
    return entity;
  }

  Future<List<T>> getEntityBySearchKey(String searchKey, dynamic value) async {
    final db = await dbProvider.database;
    List<Map> listOfDBData = await db.query(
      getTableName(),
      where: '$searchKey = ?',
      whereArgs: [value],
    );
    return fromList(listOfDBData);
    ;
  }

  Future<List<T>> getAll() async {
    final db = await dbProvider.database;
    List<Map> listOfDBData = await db.query(getTableName());
    return fromList(listOfDBData);
  }

  List<T> fromList(List<Map<String, dynamic>> listOfDBData) {
    List<T> entities = List<T>();
    for (Map map in listOfDBData) {
      entities.add(getDefaultInstance().fromMap(map));
    }
    return entities;
  }

  Future<int> update(T entity) async {
    final db = await dbProvider.database;
    return await db.update(
      getTableName(),
      entity.toMap(),
      where: '${entity.getColumnID()} = ?',
      whereArgs: [entity.getID()],
    );
  }
}
