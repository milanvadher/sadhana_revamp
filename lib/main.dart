import 'dart:io' show Platform;
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'package:sadhana/wsmodel/ws_app_setting.dart';

import 'app.dart';
import 'constant/constant.dart';

void main() {
   if (!Platform.isIOS) {
     schedulePeriodicSync();
   }
  initializeDateFormatting().then((_) => runApp(const SadhanaApp()));
}
final int periodicID = 0;

void schedulePeriodicSync() async {
  if(await AppSharedPrefUtil.isUserRegistered()) {
    await AndroidAlarmManager.initialize();
    WSAppSetting serverSetting = await AppSettingUtil.getServerAppSetting();
    await AndroidAlarmManager.periodic(Duration(minutes: serverSetting.periodicSyncIntervalInMin), periodicID, syncPeriodic, wakeup: true);
    //await AndroidAlarmManager.periodic(Duration(seconds: 10), periodicID, syncPeriodic, wakeup: true);  //Dummy
    //await AndroidAlarmManager.oneShot(const Duration(seconds: 5), oneShotID, printOneShot);
  }
}

void syncPeriodic() async {
  try {
    if(await AppUtils.isInternetConnected()) {
      print('Starting periodic sync on: ' + Constant.APP_TIME_FORMAT.format(DateTime.now()));
      await AppUtils.updateInternetDate();
      await SyncActivityUtils.syncAllUnSyncActivity(onBackground: true);
    }
    await SyncActivityUtils.checkForSyncReminder();
    await SyncActivityUtils.checkForFillReminder();
  } catch(e,s) {
    print('###### Error while background sync : $e');
    print(s);
  }
}