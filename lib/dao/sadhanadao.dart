import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/dao/basedao.dart';
import 'package:sadhana/main.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/entity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/apputils.dart';

class SadhanaDAO extends BaseDAO<Sadhana> {
  static ActivityDAO _activityDAO = ActivityDAO();

  @override
  getDefaultInstance() {
    return Sadhana(
        sadhanaName: "",
        description: "",
        type: SadhanaType.BOOLEAN,
        lColor: Constant.colors[0][0],
        dColor: Constant.colors[0][1]);
  }

  @override
  getTableName() {
    return Sadhana.tableSadhana;
  }

  Future<Sadhana> insertOrUpdate(Sadhana entity) async {
    if (AppUtils.isNullOrEmpty(entity.description)) entity.description = 'Have you done ${entity.sadhanaName} today?';
    Sadhana sadhana = await super.insertOrUpdate(entity);
    CacheData.addSadhanas([sadhana]);
    return sadhana;
  }

  @override
  Future<List<Sadhana>> getAll({bool withAllActivity = false}) async {
    List<Sadhana> sadhanas = await super.getAll();
    for (Sadhana sadhana in sadhanas) {
      List<Activity> activities = await _activityDAO.getHomeVisibleActivityBySadhanaId(sadhana.id);
      loadActivityToSadhana(sadhana, activities);
      if(withAllActivity)
        await loadAllActivity(sadhana);
      else
        loadAllActivity(sadhana);
    }
    sadhanas.sort((a, b) => a.index.compareTo(b.index));
    CacheData.addSadhanas(sadhanas);
    return sadhanas;
  }

  loadAllActivity(Sadhana sadhana) async {
    List<Activity> activities = await _activityDAO.getAllActivityBySadhanaId(sadhana.id);
    loadActivityToSadhana(sadhana, activities);
    sadhana.isLoadedAllActivity = true;
  }

  loadActivityToSadhana(Sadhana sadhana, List<Activity> activities) {
    if (activities != null && activities.isNotEmpty) {
      sadhana.activitiesByDate = new Map.fromIterable(
        activities,
        key: (v) => (v as Activity).sadhanaDate.millisecondsSinceEpoch,
        value: (v) => v,
      );
    } else {
      sadhana.activitiesByDate = new Map();
    }
  }

  Future<int> delete(int id) async {
    int i = await super.delete(id);
    await _activityDAO.deleteBySadhanaId(id);
    CacheData.removeSadhana(id);
    main();
    return i;
  }
}
