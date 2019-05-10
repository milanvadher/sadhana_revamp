import 'package:sadhana/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

User _user = new User();

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
create table ${_user.tableUser} ( 
  ${_user.columnId} integer primary key autoincrement, 
  ${_user.columnFirstName} text not null,
  ${_user.columnLastName} text not null,
  ${_user.columnMhtId} integer not null,
  ${_user.columnCenter} text not null)
''');
    });
  }

  Future<User> newUser(User user) async {
    final db = await database;
    var data = user.toMap();
    user.id = await db.insert(_user.tableUser, data);
    return user;
  }

  Future<User> getUser(int mhtId) async {
    final db = await database;
    List<Map> maps = await db.query(_user.tableUser,
        columns: [
          _user.columnId,
          _user.columnMhtId,
          _user.columnFirstName,
          _user.columnLastName,
          _user.columnCenter
        ],
        where: '${_user.columnMhtId} = ?',
        whereArgs: [mhtId]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(_user.tableUser, user.toMap(),
        where: '${_user.columnMhtId} = ?', whereArgs: [user.mhtId]);
  }
}
