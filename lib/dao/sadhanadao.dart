import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/dao/basedao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/entity.dart';
import 'package:sadhana/model/sadhana.dart';

class SadhanaDAO extends BaseDAO<Sadhana> {
  static final createSadhanaTable = ''' create table ${Sadhana.tableSadhana} ( 
  ${Entity.columnId} integer primary key autoincrement, 
  ${Sadhana.columnName} text not null,
  ${Sadhana.columnDescription} text,
  ${Sadhana.columnIndex} integer not null,
  ${Sadhana.columnLColor} integer not null,
  ${Sadhana.columnDColor} integer not null,
  ${Sadhana.columnType} integer not null,
  ${Sadhana.columnIsPreloaded} boolean,
  ${Sadhana.columnReminderTime} date,
  ${Sadhana.columnReminderDays} text)
''';
  ActivityDAO activityDAO = ActivityDAO();

  @override
  getDefaultInstance() {
    return Sadhana();
  }

  @override
  getTableName() {
    return Sadhana.tableSadhana;
  }

  @override
  Future<List<Sadhana>> getAll() async {
    List<Sadhana> sadhanas = await super.getAll()
    for (Sadhana sadhana in sadhanas) {
      List<Activity> activities = await activityDAO.getActivityBySadhanaId(sadhana.id);
      if (activities != null && activities.isNotEmpty) {
        sadhana.sadhanaData = new Map.fromIterable(activities, key: (v) => (v as Activity).sadhanaDate, value: (v) => v);
      } else {
        sadhana.sadhanaData = new Map();
      }
    }
    return sadhanas;
  }
}