import 'package:sadhana/dao/basedao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/entity.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';

class ActivityDAO extends BaseDAO<Activity> {

  @override
  getDefaultInstance() {
    return Activity();
  }

  @override
  getTableName() {
    return Activity.tableActivity;
  }

  @override
  Future<Activity> insertOrUpdate(Activity entity) async {
    entity.sadhanaActivityDate = DateTime.now();
    Activity activity = await super.insertOrUpdate(entity);
    CacheData.addActivity(activity);
    SyncActivityUtils.sendToServer(activity);
    return activity;
  }

  Future<List<Activity>> getActivityBySadhanaId(int sadhanaId) {
      return getEntityBySearchKey(Activity.columnSadhanaId, sadhanaId);
  }

  Future<int> deleteBySadhanaId(int sadhanaId) async {
    return await super.deleteByColumn(Activity.columnSadhanaId, sadhanaId);
  }

  Future<List<Activity>> getAllUnSyncActivity() async {
    return await getEntityBySearchKey(Activity.columnIsSynced, 0);
  }

  Future<int> updateActivitySync(Activity activity) {
      String where = getWhereAndCondition([Activity.columnSadhanaActivityDate, Entity.columnId]);
      List values = [activity.sadhanaActivityDate.millisecondsSinceEpoch, activity.id];
      return super.update(activity, where: where, values: values);
  }
}