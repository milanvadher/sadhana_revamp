import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/model/sadhana.dart';

class AppLocalNotification {
  static final AppLocalNotification _singleton = new AppLocalNotification._internal();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  AndroidNotificationDetails androidGeneralChannel = AndroidNotificationDetails(
    "General",
    "General",
    "This channel is Notifcation",
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    color: Colors.redAccent,
    largeIcon: DrawableResourceAndroidBitmap('ic_notification_large_icon'),
    //largeIconBitmapSource: BitmapSource.Drawable,
    //style: AndroidNotificationStyle.BigText,
      //styleInformation:
    //ongoing: true,  // Sticky Notification
  );
  
  BuildContext _context;
  factory AppLocalNotification() {
    return _singleton;
  }

  static initAppLocalNotification(BuildContext context) {
    _singleton._context = context;
  }

  AppLocalNotification._internal() {
    var initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = InitializationSettings(android:initializationSettingsAndroid, iOS:initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }
  
  Future<void> showNotification(String title, String msg, {int id = 1456}) async {
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android:androidGeneralChannel, iOS:iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(id, title, msg, platformChannelSpecifics);
  }

  Future<void> scheduleSadhanaDailyAtTime(Sadhana sadhana) async {
    if (sadhana.reminderTime != null) {
      Time time = Time(sadhana.reminderTime.hour, sadhana.reminderTime.minute, 0);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        sadhana.sadhanaName,
        sadhana.sadhanaName,
        sadhana.description,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        color: Colors.redAccent,
        largeIcon: DrawableResourceAndroidBitmap('ic_notification_large_icon'),
        //largeIconBitmapSource: BitmapSource.Drawable,
        //style: AndroidNotificationStyle.BigText,
        //ongoing: true,  // Sticky Notification
      );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(android:androidPlatformChannelSpecifics, iOS:iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        sadhana.id,
        sadhana.sadhanaName,
        sadhana.description,
        time,
        platformChannelSpecifics,
      );
    } else {
      cancelNotification(sadhana.id);
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    CommonFunction.alertDialog(context: _context, msg: "This is test message");
    await Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => SecondScreen(payload)),
    );
  }

  Future<void> onDidRecieveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: _context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondScreen(payload),
                    ),
                  );
                },
              )
            ],
          ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final String payload;

  SecondScreen(this.payload);

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen with payload: " + _payload),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
