import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:simple_permissions/simple_permissions.dart';

class AppCSVUtils {

  static Map<String,int> index_map = {'Vanchan': 1, 'Vidhi': 2, 'G. Satsang': 3, 'Seva': 4};
  static List<String> sadhanasName = ['Samayik','Vanchan' , 'Vidhi', 'G. Satsang', 'Seva'];

  static Future<String> writeCSV(List<List<dynamic>> rows) async {
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

  static Future<String> generateCSVBetween(DateTime from, DateTime to) async {
      List<List<dynamic>> rows = new List();
      rows.add(getHeaderRow(from.month.toString(), 'Sim-City', 'Kamlesh Kanazariya', '61758'));
      rows.add(getSadhanaRow());
      int lastDate = to.day;
      List<DateTime> dates = List.generate(lastDate, (int index) {
        return from.add(new Duration(days: index));
      });
      List<List<dynamic>> activityData = new List();
      Map<String,Sadhana> sadhanaByName = getSadhanaByName();
      for(DateTime date in dates) {
        String strDate = new DateFormat.yMd().format(date);
        List<dynamic> row = new List();
        row.add(strDate);
        for(String sadhanaName in sadhanasName) {
          Sadhana sadhana = sadhanaByName[sadhanaName];
          if(sadhana != null) {
            Activity activity = sadhana.activitiesByDate[date.millisecondsSinceEpoch];
            String value = '';
            if(sadhana.type == SadhanaType.BOOLEAN)
                value = 'N';
            else
              value = '0';
            if(activity != null) {
              if (sadhana.type == SadhanaType.BOOLEAN)
                value = activity.sadhanaValue > 0 ? 'Y' : 'N';
              else
                value = activity.sadhanaValue.toString();
            }
            row.add(value);
          }
        }
        activityData.add(row);
      }
      rows.addAll(activityData);
      return writeCSV(rows);
  }

  static List<dynamic> getHeaderRow(String month, String center, String name, String mhtId) {
    return ['Month', month, 'Center', center, 'Name', name, 'Mht ID', mhtId];
  }

  static List<dynamic> getSadhanaRow() {
    return ['Date', 'Vanchan' , 'Vidhi', 'G. Satsang', 'Seva'];
  }


  List<DateTime> getDaysToDisplay() {
    return List.generate(30, (int index) {
      return DateTime.now()..subtract(new Duration(days: index));
    });
  }

  static Map<String,Sadhana> getSadhanaByName() {
    return new Map.fromIterable(CacheData.getSadhanas(), key: (v) => (v as Sadhana).name, value: (v) => v);
  }
}
