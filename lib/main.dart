import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'package:sadhana/wsmodel/WSAppSetting.dart';
import 'app.dart';
import 'constant/constant.dart';

void main() {
  // schedulePeriodicSync();
  initializeDateFormatting().then((_) => runApp(const SadhanaApp()));
}
final int periodicID = 0;

void schedulePeriodicSync() async {
  if(await AppSharedPrefUtil.isUserRegistered()) {
    await AndroidAlarmManager.initialize();
    AppSetting serverSetting = await AppSettingUtil.getServerAppSetting();
    await AndroidAlarmManager.periodic(Duration(minutes: serverSetting.periodicSyncIntervalInMin), periodicID, syncPeriodic, wakeup: true);
    //await AndroidAlarmManager.oneShot(const Duration(seconds: 5), oneShotID, printOneShot);
  }
}

void syncPeriodic() {
  print('Starting periodic sync on' + DateFormat(Constant.APP_TIME_FORMAT).format(DateTime.now()));
  SyncActivityUtils.syncAllUnSyncActivity(onBackground: true);
}