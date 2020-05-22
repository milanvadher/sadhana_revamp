import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/fill_attendance_data.dart';
import 'package:sadhana/attendance/model/user_access.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/model/state.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class CacheData {
  static ApiService api = ApiService();
  static Map<int, Sadhana> _sadhanasById = new Map();
  static String lastSyncTime;
  static Profile _userProfile;
  static DateTime _now = new DateTime.now();
  static DateTime today = new DateTime(_now.year, _now.month, _now.day);

  static void setUserProfile(Profile userProfile) {
    _userProfile = userProfile;
  }

  static Future<Profile> getUserProfile() async {
    if (_userProfile == null) {
      _userProfile = await AppSharedPrefUtil.getUserProfile();
    }
    return _userProfile;
  }

  static Future<String> getLastSyncTime() async {
    await AppSharedPrefUtil.getStrLastSyncTime();
  }

  static SadhanaDAO sadhanaDAO = SadhanaDAO();

  static Future<Map<int, Sadhana>> getSadhanasById() async {
    if (_sadhanasById.isEmpty) {
      await sadhanaDAO.getAll(withAllActivity: true);
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

  //Attendancne
  static bool isSubmittedCurrentMonthAttendance = false;
  static DateTime pendingMonth;
  static UserAccess userAccess;

  static loadAttendanceData(BuildContext context) async {
    await loadUserAccess(context);
    if(userAccess != null && userAccess.fillAttendanceData != null) {
      FillAttendanceData fillAttendanceData = userAccess.fillAttendanceData;
      if(fillAttendanceData.attendanceType == AttendanceType.CENTER) {
        await loadPendingMonthForAttendance(fillAttendanceData.groupName, fillAttendanceData.eventName, context);
      }
    }
  }

  static loadUserAccess(BuildContext context) async {
    Response res = await api.getUserAccess();
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.status == WSConstant.SUCCESS_CODE) {
      userAccess = UserAccess.fromJson(appResponse.data);
      if (userAccess != null) {
        await AppSharedPrefUtil.saveUserAccess(userAccess);
      }
    }
  }

  static loadPendingMonthForAttendance(String group, String eventName, BuildContext context) async {
    Response res = await api.getMonthPendingForAttendance(group, eventName);
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.status == WSConstant.SUCCESS_CODE) {
      if (!AppUtils.isNullOrEmpty(appResponse.data))
        pendingMonth = WSConstant.wsDateFormat.parse(appResponse.data);
      else
        pendingMonth = null;
    }
  }

  static isAttendanceSubmissionPending() {
    return userAccess.fillAttendanceData.isCenterType && pendingMonth != null && today.month != CacheData.pendingMonth.month;
  }

  static void clear() {
    _sadhanasById = new Map();
  }
}
