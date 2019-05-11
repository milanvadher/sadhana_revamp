import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

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
create table ${Sadhana.tableSadhana} ( 
  ${Sadhana.columnId} integer primary key autoincrement, 
  ${Sadhana.columnName} text not null,
  ${Sadhana.columnDescription} text not null,
  ${Sadhana.columnIndex} integer not null,
  ${Sadhana.columnLColor} text not null),
  ${Sadhana.columnDColor} text not null),
  ${Sadhana.columnType} text not null),
  ${Sadhana.columnIsPreloaded} boolean not null),
  ${Sadhana.columnReminderTime} date not null),
  ${Sadhana.columnReminderDays} text not null),
''');
    });
  }

  Future<Sadhana> newSadhana(Sadhana sadhana) async {
    final db = await database;
    var data = sadhana.toMap();
    sadhana.id = await db.insert(Sadhana.tableSadhana, data);
    return sadhana;
  }

  Future<List<Sadhana>> getSadhana() async {
    final db = await database;
    List<Map> sadhanaData = await db.query(Sadhana.tableSadhana);
    return sadhanaData.map((sadhana)  {
      return Sadhana.fromMap(sadhana);
    });
  }

  Future<int> updateSadhana(Sadhana sadhana) async {
    final db = await database;
    return await db.update(Sadhana.tableSadhana, sadhana.toMap(),
        where: '${Sadhana.columnIndex} = ?', whereArgs: [sadhana.sadhanaIndex]);
  }
}
