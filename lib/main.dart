import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'app.dart';

//void printMessage(String msg) => print('[${DateTime.now()}] $msg');

//void printPeriodic() => printMessage("Periodic!");
//void printOneShot() => printMessage("One shot!");
void main() {
  final int periodicID = 0;
  final int oneShotID = 1;

  // Start the AlarmManager service.
  //await AndroidAlarmManager.initialize();
  //await AndroidAlarmManager.periodic(const Duration(seconds: 5), periodicID, printPeriodic, wakeup: true);
  //await AndroidAlarmManager.oneShot(const Duration(seconds: 5), oneShotID, printOneShot);
  initializeDateFormatting().then((_) => runApp(const SadhanaApp()));
}
