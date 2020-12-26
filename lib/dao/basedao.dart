import 'package:sadhana/model/entity.dart';
import 'package:sadhana/service/dbprovider.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDAO<T extends Entity> {
  DBProvider dbProvider = DBProvider.db;
  BaseDAO();
  BaseDAO.withDBProvider(DBProvider idbProvider){
    this.dbProvider = idbProvider;
  }

  getTableName();

  T getDefaultInstance();

  Future<T> insertOrUpdate(T entity) async {
    final db = await dbProvider.database;
    entity.setID(await db.insert(
      getTableName(),
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ));
    return entity;
  }

  Future<void> batchInsertOrUpdate(List<T> entities) async {
    final db = await dbProvider.database;
    Batch batch = db.batch();
    entities.forEach((entity) {
      batch.insert(
        getTableName(),
        entity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit(continueOnError: true, noResult: true);
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

  Future<List<T>> query(
      {bool distinct,
      List<String> columns,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    final db = await dbProvider.database;
    List<Map> listOfDBData = await db.query(getTableName(),
        where: where,
        columns: columns,
        distinct: distinct,
        groupBy: groupBy,
        having: having,
        limit: limit,
        offset: offset,
        orderBy: orderBy,
        whereArgs: whereArgs);
    return fromList(listOfDBData);
  }

  Future<List<T>> rawQuery(String sql) async {
    final db = await dbProvider.database;
    List<Map> listOfDBData = await db.rawQuery(sql);
    return fromList(listOfDBData);
  }

  List<T> fromList(List<Map<String, dynamic>> listOfDBData) {
    List<T> entities = List<T>();
    for (Map map in listOfDBData) {
      entities.add(getDefaultInstance().fromMap(map));
    }
    return entities;
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
