import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/main.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/notification/app_local_notification.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';
import 'package:sadhana/wsmodel/ws_sadhana_activity.dart';

class SyncActivityUtils {
  static ActivityDAO _activityDAO = ActivityDAO();
  static ApiService apiService = ApiService();
  static bool isSyncing = false;
  static final String MODULE = "[BackgroundSync]";
  static AppLocalNotification appLocalNotification = new AppLocalNotification();

  static loadActivityFromServer(List<Sadhana> sadhanas, {BuildContext context}) async {
    if (await AppSharedPrefUtil.isUserRegistered()) {
      Response res = await apiService.getActivity();
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        List<dynamic> wsActivities = appResponse.data;
        List<WSSadhanaActivity> wsSadhanaActivity = wsActivities.map((wsActivity) => WSSadhanaActivity.fromJson(wsActivity)).toList();
        Map<String, Sadhana> sadhanaByServerSName = new Map();
        sadhanas.forEach((sadhana) {
          sadhanaByServerSName[sadhana.serverSName] = sadhana;
        });
        for (WSSadhanaActivity wsSadhana in wsSadhanaActivity) {
          Sadhana sadhana = sadhanaByServerSName[wsSadhana.name];
          if (sadhana != null) {
            List<Activity> activityToInsert = [];
            for (WSActivity wsActivity in wsSadhana.data) {
              if (wsActivity.date != null) {
                Activity activity = Activity(
                  sadhanaId: sadhana.id,
                  sadhanaDate: wsActivity.date,
                  sadhanaValue: wsActivity.value,
                  isSynced: true,
                  remarks: wsActivity.remark,
                );
                activityToInsert.add(activity);
              }
            }
            await _activityDAO.batchActivityInsertForSync(sadhana, activityToInsert);
          }
        }
      }
    }
  }

  static sendToServer(Activity activity) async {
    if (await AppSharedPrefUtil.isUserRegistered() && !activity.isSynced && await AppUtils.isInternetConnected()) {
      Sadhana sadhana = (await CacheData.getSadhanasById())[activity.sadhanaId];
      WSSadhanaActivity wsSadhanaActivity = WSSadhanaActivity.fromActivity(sadhana.serverSName, [activity]);
      Response res = await apiService.syncActivity([wsSadhanaActivity]);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: null);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        activity.isSynced = true;
        _activityDAO.updateActivitySync(activity);
        _checkNUpdateForLastSyncTime();
      }
    }
  }

  static Future<void> _checkNUpdateForLastSyncTime() async {
    if (await AppSharedPrefUtil.isUserRegistered() && (await _getUnSyncActivity()).length == 0) {
      await AppSharedPrefUtil.saveLastSyncTime(DateTime.now());
      print(CacheData.lastSyncTime);
      //main();
    }
  }

  static Future<List<Activity>> _getUnSyncActivity() async {
    return await _activityDAO.getAllUnSyncActivity();
  }

  static Future<bool> syncAllUnSyncActivity({bool onBackground = true, BuildContext context, bool forceSync = false}) async {
    if (await AppSharedPrefUtil.isUserRegistered()) {
      //Dummy Notification
      //await appLocalNotification.showNotification("Sync is Running", "Date : ${DateFormat(Constant.APP_TIME_FORMAT).format(DateTime.now())}", id: 13232);
      bool isSynced = false;
      if (!isSyncing || forceSync) {
        try {
          if (await AppUtils.isInternetConnected()) {
            isSyncing = true;
            List<Activity> activities = await _getUnSyncActivity();
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
              activitiesByServerSName.forEach(
                  (serverSName, activities) => wsSadhanaActivities.add(WSSadhanaActivity.fromActivity(serverSName, activities)));
              Response res = await apiService.syncActivity(wsSadhanaActivities);
              AppResponse appResponse;
              if (onBackground)
                appResponse = AppResponseParser.parseResponse(res, context: null);
              else
                appResponse = AppResponseParser.parseResponse(res, context: context);

              if (appResponse.status == WSConstant.SUCCESS_CODE) {
                for (Activity activity in activities) {
                  activity.isSynced = true;
                  await _activityDAO.updateActivitySync(activity);
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
          await _checkNUpdateForLastSyncTime();
        }
        isSyncing = false;
      } else {
        print('Thread is already syncing.....');
      }
      return isSynced;
    }
    return true;
  }

  static Future<void> checkForSyncReminder() async {
    await CommonFunction.tryCatchAsync(null, () async {
      print('$MODULE Checking Sync Reminder');
      DateTime now = DateTime.now();
      for (DateTime reminderDate in Constant.syncReminder) {
        if (reminderDate.day == now.day && reminderDate.hour == now.hour) {
          print('$MODULE Date and Hour match ${reminderDate.day} ${reminderDate.hour}');
          if (!await _isToday(await AppSharedPrefUtil.getSyncRemindedDate())) {
            DateTime lastSynced = await AppSharedPrefUtil.getLastSyncTime();
            print('$MODULE lastSynced: $lastSynced');
            if (lastSynced == null || (lastSynced != null && lastSynced.month != now.month)) {
              print('$MODULE Displaying notification');
              await appLocalNotification.showNotification(Constant.syncReminderTitle, Constant.syncReminderBody, id: 1001);
              await AppSharedPrefUtil.saveSyncRemindedDate(now);
            }
          } else {
            print('$MODULE $now is already reminded');
          }
        }
      }
    });
  }

  static Future<void> checkForFillReminder() async {
    await CommonFunction.tryCatchAsync(null, () async {
      print('$MODULE Checking Fill Reminder');
      //appLocalNotification.showNotification("Checking fill reminder", "Date : ${DateFormat(Constant.APP_TIME_FORMAT).format(DateTime.now())}", id: 213412);
      DateTime now = DateTime.now();
      int editableDays = (await AppSettingUtil.getServerAppSetting()).editableDays;
      if (Constant.fillReminder.hour == now.hour && !await _isToday(await AppSharedPrefUtil.getFillRemindedDate())) {
        Map<int, Sadhana> sadhanaById = await CacheData.getSadhanasById();
        for (var entry in sadhanaById.entries) {
          Sadhana sadhana = entry.value;
          if (sadhana.isPreloaded) {
            if (isEntryExist(sadhana.activitiesByDate, editableDays)) return;
          }
        }
        print('$MODULE No any entry exist so showing notification');
        await AppLocalNotification().showNotification("Sadhana Reminder", "Don't forget to fill last $editableDays days sadhana", id: 1002);
        await AppSharedPrefUtil.saveFillRemindedDate(now);
      }
    });
  }

  static bool isEntryExist(Map<int, Activity> activitiesByDate, int days) {
    DateTime day = CacheData.today;
    //print('$MODULE all activity $activitiesByDate');
    for (int i = 0; i < days; i++) {
      //print('$MODULE ${day.millisecondsSinceEpoch} checking date ${activitiesByDate[day.millisecondsSinceEpoch]}');
      Activity activity = activitiesByDate[day.millisecondsSinceEpoch];
      if (activity != null && activity.sadhanaValue > 0) return true;
      day = day.add(Duration(days: -1));
    }
    return false;
  }

  static Future<bool> _isToday(DateTime remindedDate) async {
    return (remindedDate != null && CacheData.today.difference(remindedDate).inDays == 0);
  }
}
