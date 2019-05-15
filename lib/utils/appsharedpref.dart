import 'package:sadhana/constant/sharedpref_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefUtil {
  /*SharedPreferences pref;
  static final AppSharedPrefUtil _singleton = new AppSharedPrefUtil._internal();

  factory AppSharedPrefUtil() {
    SharedPreferences.getInstance().then((onValue) => this.pref = onValue);
    return _singleton;
  }

  AppSharedPrefUtil._internal();*/
  static Future<bool> isCreatedPreloadedSadhana() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(SharedPrefConstant.b_isCreatedPreloadedSadhana) == null
        ? false
        : pref.getBool(SharedPrefConstant.b_isCreatedPreloadedSadhana);
  }
  static void saveCreatedPreloadedSadhana(bool isCreatedPreloadedSadhana) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(SharedPrefConstant.b_isCreatedPreloadedSadhana, isCreatedPreloadedSadhana);
  }
}
