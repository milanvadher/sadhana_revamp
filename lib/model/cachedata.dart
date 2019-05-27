import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';

class CacheData {

  static Map<int, Sadhana> _sadhanasById = new Map();

  static SadhanaDAO sadhanaDAO = SadhanaDAO();
  static Future<Map<int, Sadhana>> getSadhanasById() async {
    if(_sadhanasById.isEmpty) {
      await sadhanaDAO.getAll();
    }
    return _sadhanasById;
  }

  static List<Sadhana> getSadhanas() {
    return _sadhanasById.values.toList();
  }

  static addSadhanas(List<Sadhana> sadhanas) {
    sadhanas.forEach((sadhana) => _sadhanasById[sadhana.id] = sadhana);
  }

  static removeSadhana(int id) {
    _sadhanasById.remove(id);
  }

  static addActivity(Activity activity) {
    Sadhana sadhana = _sadhanasById[activity.sadhanaId];
    if (sadhana != null) {
      sadhana.activitiesByDate[activity.sadhanaDate.millisecondsSinceEpoch] = activity;
    }
  }
}
