
import 'package:flutter/material.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/notification/onesignal_notification.dart';
import 'package:sadhana/service/apiservice.dart';

class NotificationSetup {
  static ApiService _apiService = ApiService();
  static Future<void> setupNotification({BuildContext context, Register userInfo}) async {
    try {
      //String fbToken = await FirebaseNotification.setupFBNotification(context: context);
      String fbToken = null;
      String oneSiganlPlayerId = await OneSignalNotification.setupOneSignalNotification(context: context, userInfo: userInfo);
      await _apiService.updateNotificationToken(mhtId: userInfo.mhtId, fbToken: fbToken, oneSignalToken: oneSiganlPlayerId);
    } catch(e,s) {
      print(e);print(s);
      print("Error while Notification Setup:");
    }
  }
}
