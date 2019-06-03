import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppFileUtil {
  static String sadhanaDirPath = 'Sadhana';
  static String backupDirName = 'Backups';
  static String MBAScheduleDir = "schedule";

  static Future<String> getSadhanaDir() async {
    String dir = (await getExternalStorageDirectory()).absolute.path + "/$sadhanaDirPath";
    await new Directory('$dir').create(recursive: true);
    return dir;
  }

  static Future<String> getMBAScheduleDir() async {
    String dir = (await getApplicationDocumentsDirectory()).absolute.path + "/$MBAScheduleDir";
    await new Directory('$dir').create(recursive: true);
    return dir;
  }

  static Future<String> getBackupDir() async {
    String dir = (await getExternalStorageDirectory()).absolute.path + "/$sadhanaDirPath/$backupDirName";
    new Directory('$dir').createSync(recursive: true);
    return dir;
  }

  static Future<File> writeCSV(String fileName, List<List<dynamic>> rows) async {
    //bool checkPermission = await AppUtils.checkPermission();
    bool checkPermission = true;
    if (checkPermission) {
      String dir = await AppFileUtil.getSadhanaDir();
      await new Directory('$dir').create(recursive: true);
      String file = "$dir";
      print(" FILE " + file);
      File f = new File(file + "/$fileName");
      f.createSync(recursive: true);
      String csv = const ListToCsvConverter().convert(rows);
      await f.writeAsString(csv);
      print("Successfully written file");
      return f;
    }
    return null;
  }

  static Future<File> getImageFromNetwork(String url) async {
    File file = await DefaultCacheManager().getSingleFile(url);
    return file;
  }

  static Future<File> saveImage(String url, String dir) async {
    final File file = await getImageFromNetwork(url);
    String filename = basename(file.path);
    return file.copySync('$dir/$filename');
  }
}
