import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:sadhana/utils/sync_activity_utlils.dart';
import 'app.dart';

void printMessage(String msg) => print('[${DateTime.now()}] $msg');
const platform = const MethodChannel('org.dadabhagwan.sadhana/background');
void printPeriodic() {
  printMessage("Periodic!");
  SyncActivityUtils.syncAllUnSyncActivity(onBackground: true,forceSync: true);

}
void printOneShot() => printMessage("One shot!");
void main() async {
  final int periodicID = 0;
  final int oneShotID = 1;
  // Start the AlarmManager service.
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(const Duration(seconds: 5), periodicID, printPeriodic, wakeup: true);
  //await AndroidAlarmManager.oneShot(const Duration(seconds: 5), oneShotID, printOneShot);
  _alarmManagerCallbackDispatcher();

  initializeDateFormatting().then((_) => runApp(const SadhanaApp()));
}

void _alarmManagerCallbackDispatcher() {
  // Setup Flutter state needed for MethodChannels.
  WidgetsFlutterBinding.ensureInitialized();

  // This is where the magic happens and we handle background events from the
  // native portion of the plugin.
  platform.setMethodCallHandler((MethodCall call) async {
    flutterFunction();
  });
}

String flutterFunction() {
  print('From Flutter Function');
  return 'From Flutter Function';
}
