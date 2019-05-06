import 'package:sadhana/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

User _user = new User();

// For user Table
final String tableUser = _user.tableUser;
final String columnId = _user.columnId;
final String columnFirstName = _user.columnFirstName;
final String columnLastName = _user.columnLastName;
final String columnMhtId = _user.columnMhtId;
final String columnCenter = _user.columnCenter;

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Sadhana.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableUser ( 
  $columnId integer primary key autoincrement, 
  $columnFirstName text not null,
  $columnLastName text not null,
  $columnMhtId integer not null,
  $columnCenter text not null)
''');
    });
  }

  Future<User> newUser(User user) async {
    final db = await database;
    var data = user.toMap();
    user.id = await db.insert(tableUser, data);
    return user;
  }

  Future<User> getUser(int mhtId) async {
    final db = await database;
    List<Map> maps = await db.query(tableUser,
        columns: [
          columnId,
          columnMhtId,
          columnFirstName,
          columnLastName,
          columnCenter
        ],
        where: '$columnMhtId = ?',
        whereArgs: [mhtId]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(tableUser, user.toMap(),
        where: '$columnMhtId = ?', whereArgs: [user.mhtId]);
  }
}
