import 'dart:io';

import 'package:intl/intl.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/app_file_util.dart';
import 'package:sadhana/utils/apputils.dart';

class AppCSVUtils {
  static List<String> sadhanasName = ['Samayik', 'Vanchan', 'Vidhi', 'G. Satsang', 'Seva'];
  static final MONTHS_NAMES = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  static String getFileName(DateTime from) {
    String month = DateFormat('MMM_yyyy').format(from);
    return 'Kamlesh_Kanazariya_61758_$month';
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
    totals.insert(0, 'Total');
    rows.add(totals);
    return await AppFileUtil.writeCSV(getFileName(from), rows);
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
