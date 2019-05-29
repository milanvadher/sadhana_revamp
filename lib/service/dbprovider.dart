import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/appcsvutils.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Sadhana.db");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute(Sadhana.createSadhanaTable);
      await db.execute(Activity.createActivityTable);
    });
  }

  Future<File> exportDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Sadhana.db");
    File dbFile = new File(path);
    String backupDir = await AppCSVUtils.getBackupDir();
    String fileName = 'Sadhana_' + DateFormat(Constant.APP_DATE_FORMAT).format(DateTime.now()) + '.db';
    return await dbFile.copy('$backupDir/$fileName');
  }
}
