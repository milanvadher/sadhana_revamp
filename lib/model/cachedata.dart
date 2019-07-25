import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/appsharedpref.dart';

class CacheData {

  static Map<int, Sadhana> _sadhanasById = new Map();
  static String lastSyncTime;
  static Profile _userProfile;
  static bool isSubmittedCurrentMonthAttendance = false;

  static void setUserProfile(Profile userProfile) {
    _userProfile = userProfile;
  }

  static Future<Profile> getUserProfile() async {
    if(_userProfile == null) {
      _userProfile = await AppSharedPrefUtil.getUserProfile();
    }
    return _userProfile;
  }

  static Future<String> getLastSyncTime() async {
    await AppSharedPrefUtil.getLastSyncTime();
  }

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

  static addActivities(List<Activity> activities) {
    activities.forEach((activity) => addActivity(activity));
  }
}
