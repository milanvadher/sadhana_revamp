// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// class FirebaseNotification {
//  static FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
//
//  static Future<String> setupFBNotification({BuildContext context}) async {
//    try {
//      firebaseMessaging.configure(
//          onLaunch: (Map<String, dynamic> msg) {
//            print('onLaunch called');
//          },
//          onMessage: (Map<String, dynamic> msg) {
//            print('onMessage called');
//          },
//          onResume: (Map<String, dynamic> msg) {
//            print('onResume called');
//          }
//      );
//
//      firebaseMessaging.requestNotificationPermissions(
//          const IosNotificationSettings(
//              sound: true,
//              alert: true,
//              badge: true
//          ));
//
//      firebaseMessaging.onIosSettingsRegistered.listen((
//          IosNotificationSettings setting) {
//        print('IOS Setting');
//      });
//      String token = await firebaseMessaging.getToken();
//      return token;
//    } catch (err) {
//      print(err);
//      print(err);
//      if (context != null) {
//        print('CATCH :: ');
//        print(err);
//        // CommonFunction.displayErrorDialog(context: context, msg: err.toString());
//      }
//    }
//    return null;
//  }
// }