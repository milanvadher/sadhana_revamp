import 'package:sadhana/dao/basedao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/entity.dart';
import 'package:sadhana/model/sadhana.dart';

class ActivityDAO extends BaseDAO<Activity> {
  static final createActivityTable = ''' create table ${Activity.tableActivity} ( 
  ${Entity.columnId} integer primary key autoincrement, 
  ${Activity.columnSadhanaId} integer not null,
  ${Activity.columnSadhanaDate} integer not null ON CONFLICT REPLACE,
  ${Activity.columnSadhanaActivityDate} integer not null,
  ${Activity.columnSadhanaValue} integer not null,
  ${Activity.columnIsSynced} integer,
  ${Activity.columnRemarks} text)
''';

  @override
  getDefaultInstance() {
    return Activity();
  }

  @override
  getTableName() {
    return Activity.tableActivity;
  }
  Future<List<Activity>> getActivityBySadhanaId(int sadhanaId) {
      return getEntityBySearchKey(Activity.columnSadhanaId, sadhanaId);
  }

}