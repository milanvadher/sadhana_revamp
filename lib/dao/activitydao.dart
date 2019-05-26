import 'package:sadhana/dao/basedao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/entity.dart';

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
  Future<Activity> insertOrUpdate(Activity entity) async {
    entity.sadhanaActivityDate = DateTime.now();
    Activity activity = await super.insertOrUpdate(entity);
    sendToServer(activity);
    return activity;
  }

  sendToServer(Activity activity) {
    if(!activity.isSynced) {
      bool isSendToServer = true;
      if(isSendToServer) {
        activity.isSynced = true;
        updateActivitySync(activity);
      }
    }
  }

  Future<List<Activity>> getActivityBySadhanaId(int sadhanaId) {
      return getEntityBySearchKey(Activity.columnSadhanaId, sadhanaId);
  }

  Future<int> deleteBySadhanaId(int sadhanaId) async {
    return await super.deleteByColumn(Activity.columnSadhanaId, sadhanaId);
  }

  Future<int> updateActivitySync(Activity activity) {
      String where = getWhereAndCondition([Activity.columnSadhanaActivityDate, Entity.columnId]);
      List values = [activity.sadhanaActivityDate.millisecondsSinceEpoch, activity.id];
      return super.update(activity, where: where, values: values);
  }
}