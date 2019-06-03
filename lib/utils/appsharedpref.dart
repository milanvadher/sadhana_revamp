import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sharedpref_constant.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/wsmodel/WSAppSetting.dart';
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

  static Future<void> saveString(String prefStr, String value) async {
    await loadPref();
    _pref.setString(prefStr, value);
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

  static Future<void> saveLasySyncTime(DateTime lastSyncTime) async {
    String sLastSyncTime = DateFormat(Constant.APP_DATE_TIME_FORMAT).format(lastSyncTime);
    CacheData.lastSyncTime = sLastSyncTime;
    return saveString(SharedPrefConstant.s_last_sync_time, sLastSyncTime);
  }

  static Future<String> getLastSyncTime() async {
    String sLastSyncTime = await getString(SharedPrefConstant.s_last_sync_time);
    CacheData.lastSyncTime = sLastSyncTime;
    return sLastSyncTime;
  }

  static Future<String> getToken() async {
    return await getString('token');
  }

  static Future<AppSetting> getServerSetting() async {
    String serverSetting = await getString(SharedPrefConstant.s_server_setting);
    if(serverSetting == null) {
      return AppSetting.getDefaulServerAppSetting();
    } else {
      return json.decode(serverSetting);
    }
  }

  static Future<void> saveServerSetting(AppSetting appSetting) async {
    await saveString(SharedPrefConstant.s_server_setting, json.encode(appSetting));
  }

  static Future<String> getMBAScheduleFilePath() async {
    return await getString(SharedPrefConstant.s_mba_schedule_file_path);
  }

  static Future<void> saveMBAScheduleFilePath(String filePath) async {
    return await saveString(SharedPrefConstant.s_mba_schedule_file_path, filePath);
  }

  static Future<DateTime> getMBAScheduleMonth() async {
    String strDate = await getString(SharedPrefConstant.s_mba_schedule_month);
    if(strDate != null)
      return DateFormat(Constant.APP_MONTH_FORMAT).parse(strDate);
    else
      return null;
  }

  static Future<void> saveMBAScheduleMonth(String month) async {
    return await saveString(SharedPrefConstant.s_mba_schedule_month, month);
  }

  static Future<void> saveMBASchedule(DateTime date, String filePath) async {
    await saveMBAScheduleFilePath(filePath);
    String strDate = DateFormat(Constant.APP_MONTH_FORMAT).format(date);
    await saveMBAScheduleMonth(strDate);
  }

}
