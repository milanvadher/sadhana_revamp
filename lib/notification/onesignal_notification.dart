import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/model/register.dart';

class OneSignalNotification {
  static final String ONESIGANL_APPID = "a2e2c4fd-40b8-49e9-aa78-8d6770a11007"; //Live

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  static bool _requireConsent = true;

  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<String> setupOneSignalNotification(
      {BuildContext context, Register userInfo}) async {
    String playerId;
    //OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.debug);
    try {
      OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

      var settings = {
        OSiOSSettings.autoPrompt: true,
        OSiOSSettings.promptBeforeOpeningPushUrl: true
      };

      OneSignal.shared.setNotificationReceivedHandler((notification) {
        print(
            "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      });

      OneSignal.shared
          .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        print(
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      });

      OneSignal.shared
          .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
      });

      OneSignal.shared
          .setPermissionObserver((OSPermissionStateChanges changes) {
        print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
      });

      OneSignal.shared.setEmailSubscriptionObserver(
          (OSEmailSubscriptionStateChanges changes) {
        print(
            "EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
      });

      // NOTE: Replace with your own app ID from https://www.onesignal.com
      await OneSignal.shared.init(ONESIGANL_APPID, iOSSettings: settings);

      OneSignal.shared
          .setInFocusDisplayType(OSNotificationDisplayType.notification);

      OneSignal.shared.consentGranted(true);

      OSPermissionSubscriptionState status =  await OneSignal.shared.getPermissionSubscriptionState();
      print(status.jsonRepresentation());
      playerId = status.subscriptionStatus.userId;
      print(playerId);


      if (userInfo != null) {
        Map<String, dynamic> tags = Map();
        tags['mhtId'] = userInfo.mhtId;
        tags['mobile'] = userInfo.mobileNo1;
        tags['name'] = '${userInfo.firstName} ${userInfo.lastName}';
        _sendTags(tags);
        if (userInfo.mhtId != null)
          _setExternalUserId(userInfo.mhtId.toString());
      }
      //bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
    } catch (err) {
      print(err);
      if (context != null) {
        print('CATCH :: ');
        print(err);
        CommonFunction.displayErrorDialog(
            context: context, msg: err.toString());
      }
    }
    return playerId;
  }

  static void _setEmail(String emailAddress) {
    if (emailAddress == null) return;
    OneSignal.shared.setEmail(email: emailAddress).whenComplete(() {
      print("Successfully set email");
    }).catchError((error) {
      print("Failed to set email with error: $error");
    });
  }

  static void _sendTags(Map<String, dynamic> tags) {
    OneSignal.shared.sendTags(tags).then((response) {
      print("Successfully sent tags with response: $response");
    }).catchError((error) {
      print("Encountered an error sending tags: $error");
    });
  }

  static void _setExternalUserId(String externalUserId) {
    OneSignal.shared.setExternalUserId(externalUserId);
  }

  void _handleGetTags() {
    OneSignal.shared.getTags().then((tags) {
      if (tags == null) return;
      print("$tags");
    }).catchError((error) {
      print("$error");
    });
  }

  void _handlePromptForPushPermission() {
    print("Prompting for Permission");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  void _handleGetPermissionSubscriptionState() {
    print("Getting permissionSubscriptionState");
    OneSignal.shared.getPermissionSubscriptionState().then((status) {
      print(status.jsonRepresentation());
    });
  }

  void _handleLogoutEmail() {
    print("Logging out of email");
    OneSignal.shared.logoutEmail().then((v) {
      print("Successfully logged out of email");
    }).catchError((error) {
      print("Failed to log out of email: $error");
    });
  }

  void _handleConsent() {
    print("Setting consent to true");
    OneSignal.shared.consentGranted(true);
    print("Setting state");
  }

  void _handleSetLocationShared() {
    print("Setting location shared to true");
    OneSignal.shared.setLocationShared(true);
  }

  void _handleDeleteTag() {
    print("Deleting tag");
    OneSignal.shared.deleteTag("test2").then((response) {
      print("Successfully deleted tags with response $response");
    }).catchError((error) {
      print("Encountered error deleting tag: $error");
    });
  }

  // void _handleSetExternalUserId() {
  //   print("Setting external user ID");
  //   OneSignal.shared.setExternalUserId(_externalUserId);
  // }

  // void _handleRemoveExternalUserId() {
  //   OneSignal.shared.removeExternalUserId();
  // }

  void _handleSendNotification() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;

    var imgUrlString =
        "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

    var notification = OSCreateNotification(
        playerIds: [playerId],
        content: "this is a test from OneSignal's Flutter SDK",
        heading: "Test Notification",
        iosAttachments: {"id1": imgUrlString},
        bigPicture: imgUrlString,
        buttons: [
          OSActionButton(text: "test1", id: "id1"),
          OSActionButton(text: "test2", id: "id2")
        ]);

    var response = await OneSignal.shared.postNotification(notification);
    print("Sent notification with response: $response");
  }

  void _handleSendSilentNotification() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    var playerId = status.subscriptionStatus.userId;

    var notification = OSCreateNotification.silentNotification(
        playerIds: [playerId], additionalData: {'test': 'value'});

    var response = await OneSignal.shared.postNotification(notification);
    print("Sent notification with response: $response");
  }
}
