import 'package:sadhana/constant/sharedpref_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefUtil {
  static SharedPreferences _pref;

/*static final AppSharedPrefUtil _singleton = new AppSharedPrefUtil._internal();

  factory AppSharedPrefUtil() {
    SharedPreferences.getInstance().then((onValue) => this.pref = onValue);
    return _singleton;
  }

  AppSharedPrefUtil._internal()*/

  static Future<void> loadPref() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future<void> saveBoolean(String prefStr, bool isDone) async {
    await loadPref();
    _pref.setBool(prefStr, isDone);
  }

  static Future<bool> getBool(String prefStr, {bool defaultValue = false}) async {
    await loadPref();
    return _pref.getBool(prefStr) == null ? defaultValue : _pref.getBool(prefStr);
  }

  static Future<String> getString(String prefStr, {String defaultValue}) async {
    await loadPref();
    return _pref.getString(prefStr) == null ? defaultValue : _pref.getString(prefStr);
  }

  static Future<bool> isCreatedPreloadedSadhana() async {
    return await getBool(SharedPrefConstant.b_isCreatedPreloadedSadhana);
  }

  static Future<void> saveCreatedPreloadedSadhana(bool isCreatedPreloadedSadhana) async {
    await saveBoolean(SharedPrefConstant.b_isCreatedPreloadedSadhana, isCreatedPreloadedSadhana);
  }

  static Future<bool> isCreatedPreloadedActivity() async {
    return await getBool(SharedPrefConstant.b_isCreatedPreloadedActivity);
  }

  static Future<void> saveCreatedPreloadedActivity(bool isCreatedPreloadedActivity) async {
    await saveBoolean(SharedPrefConstant.b_isCreatedPreloadedSadhana, isCreatedPreloadedActivity);
  }

  static Future<bool> isUserLoggedIn() async {
    return await getBool(SharedPrefConstant.b_isUserLoggedIn, defaultValue: false);
  }

  static Future<String> getToken() async {
    return await getString('token');
  }
}
