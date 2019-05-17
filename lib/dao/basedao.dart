import 'package:sadhana/model/entity.dart';
import 'package:sadhana/service/dbprovider.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDAO<T extends Entity> {
  DBProvider dbProvider = DBProvider.db;

  getTableName();

  T getDefaultInstance();

  Future<T> insertOrUpdate(T entity) async {
    final db = await dbProvider.database;
    entity.setID(await db.insert(getTableName(), entity.toMap(), conflictAlgorithm: ConflictAlgorithm.replace));
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

  Future<int> update(T entity, {String where, List<dynamic> values}) async {
    final db = await dbProvider.database;
    return await db.update(
      getTableName(),
      entity.toMap(),
      where: where,
      whereArgs: values,
    );
  }

/*  Future<int> updateWithWhere(T entity, {String where, List<dynamic> values}) async {
    final db = await dbProvider.database;
    return await db.update(
      getTableName(),
      entity.toMap(),
      where: where,
      whereArgs: values,
    );
  }*/

  String getWhereAndCondition(List<String> columns) {
    String where = '';
    bool first = true;
    for (String column in columns) {
      if (first)
        where = where + '$column = ?';
      else
        where = where + 'and $column = ?';
      first = false;
    }
    return where;
  }

  Future<int> delete(int id) async {
    final db = await dbProvider.database;
    return await db.delete(getTableName(), where: '${Entity.columnId} = ?', whereArgs: [id]);
  }

  Future<int> deleteByColumn(String columnName, dynamic value) async {
    final db = await dbProvider.database;
    return await db.delete(getTableName(), where: '$columnName = ?', whereArgs: [value]);
  }
}
