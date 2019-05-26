import 'package:sadhana/dao/basedao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/entity.dart';

class ActivityDAO extends BaseDAO<Activity> {

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
    CacheData.addActivity(activity);
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