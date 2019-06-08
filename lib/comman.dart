import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/constant/message_constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/notification/notifcation_setup.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/setup/options.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class CommonFunction {
  static AppOptionsPage appOptionsPage;

  static displayErrorDialog({@required BuildContext context, String msg}) {
    if (msg != null && msg.toUpperCase().contains("SOCKET")) msg = "Looks like you lost your Internet !!";
    if (msg == null) msg = MessageConstant.COMMON_ERROR_MSG;
    if(context != null) {
      alertDialog(
        context: context,
        msg: msg,
        type: 'error',
        barrierDismissible: false,
      );
    }
  }

  static displayInernetNotAvailableDialog({@required BuildContext context}) {
    if(context != null) {
      alertDialog(
        context: context,
        msg: 'Internet is not available, Please connect to internet and retry',
        type: 'error',
        barrierDismissible: false,
      );
    }
  }

  // email Validation
  static String emailValidation(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email-Id is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter valid Email-Id';
    }
    return null;
  }

  static String mobileValidation(String value) {
    if (value.isEmpty) {
      return 'Mobile no. is required';
    } else if (value.length != 10) {
      return 'Enter valid Mobile no.';
    }
    return null;
  }



  static Future<bool> registerUser({@required Register register, @required BuildContext context, bool generateToken = true}) async {
    if(generateToken) {
      ApiService apiService = ApiService();
      Response res = await apiService.generateToken(register.mhtId);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if(appResponse.status == WSConstant.SUCCESS_CODE) {
        if (appResponse.data != null && appResponse.data.toString().isNotEmpty)
          register.token = appResponse.data;
      }
    }
    if(register.token != null) {
      AppSharedPrefUtil.saveToken(register.token);
      Profile profile = Profile.fromRegisterModel(register);
      loginUser(profile: profile);
      AppSharedPrefUtil.saveRegisterProfile(register);
      AppSharedPrefUtil.saveIsUserRegistered(true);
      await NotificationSetup.setupNotification(userInfo: register, context: context);
      return true;
    }
    return false;
  }

  static Future<bool> loginUser({@required Profile profile}) async {
    AppSharedPrefUtil.saveMhtId(profile.mhtId);
    AppSharedPrefUtil.saveUserProfile(profile);
    AppSharedPrefUtil.saveUserLoggedIn(true);
    return true;
  }

  // common Alert dialog
  static alertDialog({
    @required BuildContext context,
    String type = 'info', // 'success' || 'error'
    String title,
    @required String msg,
    bool showDoneButton = true,
    String doneButtonText = 'OK',
    String cancelButtonText = 'Cancel',
    Function doneButtonFn,
    bool barrierDismissible = true,
    bool showCancelButton = false,
    Function doneCancelFn,
    AlertDialog Function() builder,
    Widget widget,
    bool closeable = true
  }) {
    if(context != null) {
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) {
          return WillPopScope(
              onWillPop: () async => closeable,
              child: AlertDialog(
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    widget != null ? widget : Container(),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        msg != null
                            ? msg
                            : type == 'error' ? "Looks like your lack of \n Imagination ! " : "Looks like today is your luckyday ... !!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blueGrey, height: 1.5),
                        textScaleFactor: 1.1,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          color: type == 'error' ? kQuizErrorRed : Colors.green[600],
                          child: Row(
                            children: <Widget>[
                              Text(
                                doneButtonText = doneButtonText?? "OK",
                                textScaleFactor: 1.2,
                                style: TextStyle(color: kQuizBackgroundWhite),
                              )
                            ],
                          ),
                          onPressed: doneButtonFn != null
                              ? doneButtonFn
                              : () {
                            Navigator.pop(context);
                          },
                        ),
                        showCancelButton ? SizedBox(width: 10) : new Container(),
                        showCancelButton
                            ? FlatButton(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            color: kQuizErrorRed,
                            child: Row(
                              children: <Widget>[Text(cancelButtonText?? 'Cancel', textScaleFactor: 1.2, style: TextStyle(color: kQuizBackgroundWhite))],
                            ),
                            onPressed: doneCancelFn != null
                                ? doneCancelFn
                                : () {
                              Navigator.pop(context);
                            })
                            : new Container(),
                      ],
                    ),
                  ],
                ),
              ));
        },
      );
    }
  }

}
