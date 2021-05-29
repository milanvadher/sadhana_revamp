// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/event_attendance.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/device_info_utils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'Sadhana Notifications', // title
  'This channel is used for sadhana related notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class FireBaseNotificationSetup {
  static Future<void> initFirebaseOnAppLaunch() async {
    if(!await AppSharedPrefUtil.isUserRegistered()) {
      return;
    }
    await Firebase.initializeApp();
    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    subScribeTopic('allUser');
    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      print("@@@@@@@@@@@@@@@@@@@@ inside getInitialMessage $message");
      if (message != null) {
        // Navigator.pushNamed(context, '/message', arguments: MessageArguments(message, true));
      }
    });
    updateFCMToken();
  }

  static void initToHandleForegroundNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.red
                // icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EventAttendance(myAttendance: true)),
      );
    });
  }

  requestPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  static subScribeTopic(String topic) async {
    print('FlutterFire Messaging Example: Subscribing to topic $topic.');
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('FlutterFire Messaging Example: Subscribing to topic $topic successful.');
  }

  static unSubScribeToken(String topic) async {
    print('FlutterFire Messaging Example: Unsubscribing from topic $topic.');
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    print('FlutterFire Messaging Example: Unsubscribing from topic topic successful.');
  }

  static updateFCMToken({String mhtId}) async {
    if(AppUtils.isNullOrEmpty(mhtId)) {
      Profile profile = await CacheData.getUserProfile();
      if(profile != null) mhtId = profile.mhtId;
    }
    _getFCMToken(mhtId);
  }

  static _getFCMToken(String mhtId) async {
    String token = await FirebaseMessaging.instance.getToken();
    print(' FCM Token $token');
    if(AppUtils.isNullOrEmpty(await AppSharedPrefUtil.getFCMToken()) && !AppUtils.isNullOrEmpty(mhtId)) {
      Map<String,dynamic> deviceInfo = await DeviceInfoUtils.getDeviceInfo();
      Response res = await ApiService().updateFCMNotificationToken(mhtId:mhtId, fcmToken:token, deviceInfo: deviceInfo);
      AppResponse appRes = AppResponseParser.parseResponse(res, context: null);
      if(appRes.isSuccess) {
        AppSharedPrefUtil.saveFCMToken(token, deviceInfo);
      }
    }
  }

  static getAPNSToken() async {
    if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      print('FlutterFire Messaging Example: Getting APNs token...');
      String token = await FirebaseMessaging.instance.getAPNSToken();
      print('FlutterFire Messaging Example: Got APNs token: $token');
    } else {
      print('FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
    }
  }
}
