import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/apputils.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:permission/permission.dart';

class AppCSVUtils {
  static List<String> sadhanasName = ['Samayik', 'Vanchan', 'Vidhi', 'G. Satsang', 'Seva'];

  static String sadhanaDirPath = 'Sadhana';
  static String backupDirName = 'Backup';
  static Future<File> writeCSV(String fileName, List<List<dynamic>> rows) async {
    //await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    //bool checkPermission = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
    bool checkPermission;
    if(Platform.isAndroid) {
      await Permission.requestPermissions([PermissionName.Storage]);
      List<Permissions> permissions = await Permission.getPermissionsStatus([PermissionName.Storage]);
      if(permissions != null && permissions.isNotEmpty) {
        checkPermission = permissions.single.permissionStatus == PermissionStatus.allow ? true : false;
      }
    } else {
      await Permission.requestSinglePermission(PermissionName.Storage);
      PermissionStatus permissionStatus = await Permission.getSinglePermissionStatus(PermissionName.Storage);
        checkPermission = permissionStatus == PermissionStatus.allow ? true : false;
    }
    if (checkPermission) {
      String dir = await getSadhanaDir();
      String file = "$dir";
      print(" FILE " + file);
      File f = new File(file + "/$fileName");
      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
      print("Successfully written file");
      return f;
    }
    return null;
  }

  static String getFileName(int month) {
    return "61758_$month.csv";
  }

  static Future<String> getSadhanaDir() async {
    String dir = (await getExternalStorageDirectory()).absolute.path + "/$sadhanaDirPath";
    await new Directory('$dir').create(recursive: true);
    return dir;
  }

  static Future<String> getBackupDir() async {
    String dir = (await getExternalStorageDirectory()).absolute.path + "/$sadhanaDirPath/$backupDirName";
    await new Directory('$dir').create(recursive: true);
    return dir;
  }

  static Future<File> generateCSVBetween(DateTime from, DateTime to) async {
    List<List<dynamic>> rows = new List();
    rows.add(getHeaderRow(from.month.toString(), 'Sim-City', 'Kamlesh Kanazariya', '61758'));
    rows.add(getSadhanaRow());
    int lastDate = to.day;
    List<DateTime> dates = List.generate(lastDate, (int index) {
      return from.add(new Duration(days: index));
    });
    List<List<dynamic>> activityData = new List();
    Map<String, Sadhana> sadhanaByName = getSadhanaByName();
    List totals = new List.filled(sadhanasName.length, 0, growable: true);
    for (DateTime date in dates) {
      String strDate = new DateFormat.yMd().format(date);
      List<dynamic> row = new List();
      row.add(strDate);
      sadhanasName.asMap().forEach((index, sadhanaName) {
        Sadhana sadhana = sadhanaByName[sadhanaName];
        if (sadhana != null) {
          Activity activity = sadhana.activitiesByDate[date.millisecondsSinceEpoch];
          String value = '';
          if (sadhana.type == SadhanaType.BOOLEAN)
            value = 'N';
          else
            value = '0';
          if (activity != null) {
            if (sadhana.type == SadhanaType.BOOLEAN) {
              if (activity.sadhanaValue > 0) {
                value = activity.sadhanaValue > 0 ? 'Y' : 'N';
                totals[index]++;
              }
            } else {
              value = activity.sadhanaValue.toString();
              totals[index] = totals[index] + activity.sadhanaValue;
            }
          }
          row.add(value);
          if (activity != null && AppUtils.equalsIgnoreCase(sadhana.sadhanaName, Constant.SEVANAME)) {
            row.add(activity.remarks);
          }
        }
      });
      activityData.add(row);
    }
    rows.addAll(activityData);
    totals.insert(0,'Total');
    rows.add(totals);
    return await writeCSV(getFileName(from.month),rows);
  }

  static List<dynamic> getHeaderRow(String month, String center, String name, String mhtId) {
    return ['Month', month, 'Center', center, 'Name', name, 'Mht ID', mhtId];
  }

  static List<dynamic> getSadhanaRow() {
    List<String> sadhanaRow = new List();
    sadhanaRow.add('Date');
    sadhanaRow.addAll(sadhanasName);
    sadhanaRow.add('Seva Remarks');
    return sadhanaRow;
  }

  List<DateTime> getDaysToDisplay() {
    return List.generate(30, (int index) {
      return DateTime.now()..subtract(new Duration(days: index));
    });
  }

  static Map<String, Sadhana> getSadhanaByName() {
    return new Map.fromIterable(CacheData.getSadhanas(), key: (v) => (v as Sadhana).sadhanaName, value: (v) => v);
  }
}
