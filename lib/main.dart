import 'dart:io' show Platform;
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'package:sadhana/wsmodel/ws_app_setting.dart';

import 'app.dart';
import 'constant/constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isIOS) {
    await schedulePeriodicSync();
  }
  await initializeDateFormatting();
  runApp(const SadhanaApp());
}

final int periodicID = 0;

Future<void> schedulePeriodicSync() async {
  if(await AppSharedPrefUtil.isUserRegistered()) {
    await AndroidAlarmManager.initialize();
    WSAppSetting serverSetting = await AppSharedPrefUtil.getServerSetting();
    await AndroidAlarmManager.periodic(Duration(minutes: serverSetting.periodicSyncIntervalInMin), periodicID, syncPeriodic, wakeup: true);
    //await AndroidAlarmManager.periodic(Duration(minutes: 1), periodicID, syncPeriodic, wakeup: true);  //Dummy
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
