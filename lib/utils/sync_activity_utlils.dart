import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/main.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';
import 'package:sadhana/wsmodel/ws_sadhana_activity.dart';

class SyncActivityUtils {
  static ActivityDAO _activityDAO = ActivityDAO();
  static ApiService apiService = ApiService();
  static bool isSyncing = false;


  static sendToServer(Activity activity) async {
    if (!activity.isSynced && await AppUtils.isInternetConnected()) {
      Sadhana sadhana = (await CacheData.getSadhanasById())[activity.sadhanaId];
      WSSadhanaActivity wsSadhanaActivity = WSSadhanaActivity.fromActivity(sadhana.serverSName, [activity]);
      Response res = await apiService.syncActivity([wsSadhanaActivity]);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: null);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        activity.isSynced = true;
        _activityDAO.updateActivitySync(activity);
        checkNUpdateForLastSyncTime();
      }
    }
  }

  static Future<void> checkNUpdateForLastSyncTime() async {
    if ((await getUnSyncActivity()).length == 0) {
      await AppSharedPrefUtil.saveLasySyncTime(DateTime.now());
      print(CacheData.lastSyncTime);
      main();
    }
  }

  static Future<List<Activity>> getUnSyncActivity() async {
    return await _activityDAO.getAllUnSyncActivity();
  }

  static Future<bool> syncAllUnSyncActivity({bool onBackground = true, BuildContext context, bool forceSync = false}) async {
    bool isSynced = false;
    if (!isSyncing || forceSync) {
      try {
        if (await AppUtils.isInternetConnected()) {
          isSyncing = true;
          List<Activity> activities = await getUnSyncActivity();
          if (activities.length > 0) {
            Map<int, Sadhana> sadhanaById = await CacheData.getSadhanasById();
            Map<String, List<Activity>> activitiesByServerSName = new Map();
            for (Activity activity in activities) {
              Sadhana sadhana = sadhanaById[activity.sadhanaId];
              if (sadhana != null) {
                List<Activity> mapActivities = activitiesByServerSName[sadhana.serverSName];
                if (mapActivities == null) mapActivities = List();
                mapActivities.add(activity);
                activitiesByServerSName[sadhana.serverSName] = mapActivities;
              }
            }
            List<WSSadhanaActivity> wsSadhanaActivities = new List();
            activitiesByServerSName
                .forEach((serverSName, activities) => wsSadhanaActivities.add(WSSadhanaActivity.fromActivity(serverSName, activities)));
            Response res = await apiService.syncActivity(wsSadhanaActivities);
            AppResponse appResponse;
            if (onBackground)
              appResponse = AppResponseParser.parseResponse(res, context: null);
            else
              appResponse = AppResponseParser.parseResponse(res, context: context);

            if (appResponse.status == WSConstant.SUCCESS_CODE) {
              for (Activity activity in activities) {
                activity.isSynced = true;
                _activityDAO.updateActivitySync(activity);
              }
              isSynced = true;
            }
          } else
            isSynced = true;
        } else {
          print('Internet is not available to sync all');
        }
      } catch (error) {
        isSyncing = false;
        print('Error while sync all activity:' + error);
        throw error;
      }
      if (isSynced) {
        print('All activity is synced successfully');
        await checkNUpdateForLastSyncTime();
      }
      isSyncing = false;
    } else {
      print('Thread is already syncing.....');
    }
    return isSynced;
  }
}
