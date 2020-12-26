import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/app_file_util.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  DBProvider(Database database) {
    _database = database;
  }
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDB(await _getDBPath());
    return _database;
  }

  _getDBPath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return join(documentsDirectory.path, "Sadhana.db");
  }

  static getDB(String path) async {
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute(Sadhana.createSadhanaTable);
      await db.execute(Activity.createActivityTable);
    });
  }

  Future<File> exportDB() async {
    if(Platform.isIOS || await AppUtils.askForPermission()) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "Sadhana.db");
      File dbFile = new File(path);
      String backupDir = await AppFileUtil.getBackupDir();
      String fileName = 'Sadhana_Backup_' + DateFormat(Constant.APP_DATE_TIME_FILE_FORMAT).format(DateTime.now()) + '.db';
      return await dbFile.copy('$backupDir/$fileName');
    }
    return null;
  }

  void deleteDB() async {
    _database.close();
    File file = File(await _getDBPath());
    file.deleteSync();
    _database = null;
  }
}
