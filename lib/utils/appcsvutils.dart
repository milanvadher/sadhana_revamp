import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:sadhana/model/activity.dart';
import 'package:simple_permissions/simple_permissions.dart';

class AppCSVUtils {
  static Future<String> generateCSV(List<Activity> associateList) async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    for (int i = 0; i < associateList.length; i++) {
      List<dynamic> row = List();
      row.add(associateList[i].sadhanaId);
      row.add(associateList[i].sadhanaValue);
      row.add(associateList[i].sadhanaDate);
      row.add(associateList[i].remarks);
      rows.add(row);
    }
    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    bool checkPermission = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    if (checkPermission) {
      String dir = (await getExternalStorageDirectory()).absolute.path + "/Sadhana";
      await new Directory('$dir').create(recursive: true);
      String file = "$dir";
      print(" FILE " + file);
      File f = new File(file + "/sadhanaactivity.csv");
      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
      print("Successfully written file");
      return file;
    }
    return null;
  }
}
