import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
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
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class CommonFunction {
  static AppOptionsPage appOptionsPage;

  static displayErrorDialog({@required BuildContext context, String msg, String error}) {
    if (msg != null && msg.toUpperCase().contains("SOCKET")) msg = "Looks like you lost your Internet !!";
    if (msg == null) msg = MessageConstant.COMMON_ERROR_MSG;
    if (context != null) {
      alertDialog(
        context: context,
        msg: msg,
        type: 'error',
        barrierDismissible: false,
        errorHint: error,
      );
    }
  }

  static Future<void> wrapWithTryCatch(BuildContext context, Function function, {String msg}) async {
    try {
      await function();
    } catch(e,s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context, error: e);
    }
  }

  static Widget getTitleAndName({@required double screenWidth, @required String title, @required String value, bool forProfilePage}) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            child: Text(
              '$title',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: screenWidth - 212,
            child: Text(
              '$value',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  static Widget getTitleAndNameForProfilePage(
      {@required double screenWidth, @required String title, @required String value, double titleWidth}) {
    titleWidth = titleWidth == null ? 85 : titleWidth;
    if (title == null || title == 'null') title = '';
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Container(
            width: titleWidth,
            child: Text(
              '$title',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(":"),
          SizedBox(width: 10),
          Container(
            width: screenWidth - 160 - (titleWidth - 80),
            child: Text(
              '$value',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  static displayInternetNotAvailableDialog({@required BuildContext context}) {
    if (context != null) {
      alertDialog(
        context: context,
        msg: 'Internet is not available, Please connect to internet and retry',
        type: 'error',
        title: 'Connect Internet',
        barrierDismissible: false,
      );
    }
  }

  static String isRequiredValidation(String label, dynamic val) {
    if (val == null || (val is String && val.trim().isEmpty)) {
      return '$label is required';
    }
    return null;
  }

  // email Validation
  static String emailValidation(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email-Id is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter valid Email-Id';
    }
    return null;
  }

  static String mobileValidation(String value, {bool isRequired = true}) {
    if (isRequired && value.isEmpty) {
      return 'Mobile no. is required';
    } else if (value.isNotEmpty && value.length != 10) {
      return 'Enter valid Mobile no.';
    }
    return null;
  }

  static String mobileRegexValidator(String value, {bool isRequired = true}) {
    if (isRequired && value.isEmpty) {
      return 'Mobile no. is required';
    } else if (!AppUtils.isNullOrEmpty(value)) {
      Pattern pattern = r'^(?:[+0]9)?[0-9]{10}$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) return 'Enter Valid Mobile Number';
    }
    return null;
  }

  static Future<bool> registerUser({@required Register register, @required BuildContext context, bool generateToken = true}) async {
    if (generateToken) {
      ApiService apiService = ApiService();
      Response res = await apiService.generateToken(register.mhtId);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        if (appResponse.data != null && appResponse.data.toString().isNotEmpty) register.token = appResponse.data;
      }
    }
    if (register.token != null) {
      AppSharedPrefUtil.saveToken(register.token);
      Profile profile = Profile.fromRegisterModel(register);
      loginUser(profile: profile);
      AppSharedPrefUtil.saveMBAProfile(register);
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
  static alertDialog(
      {@required BuildContext context,
      String type = 'info', // 'success' || 'error'
      String title = '',
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
      String errorHint,
      bool closeable = true}) {
    if (context != null) {
      String newTitle = title != null ? title : type == 'error' ? 'Error' : type == 'success' ? title : 'Success';
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) {
          return WillPopScope(
              onWillPop: () async => closeable,
              child: AlertDialog(
                title: AppUtils.isNullOrEmpty(newTitle) ? null : Text(newTitle),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                content: InkWell(
                  onLongPress: errorHint == null ? () {} : () {alertDialog(context: context, msg: errorHint);},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      widget != null ? widget : Container(),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          msg != null
                              ? msg
                              : type == 'error'
                                  ? "Looks like your lack of \n Imagination ! "
                                  : "Looks like today is your luckyday ... !!",
                          style: TextStyle(color: Theme.of(context).textTheme.caption.color),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            color: type == 'error' ? kQuizErrorRed : Colors.green[600],
                            child: Text(
                              doneButtonText = doneButtonText ?? "OK",
                              style: TextStyle(color: kQuizBackgroundWhite),
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
                                  color: kQuizErrorRed,
                                  child: Text(
                                    cancelButtonText ?? 'Cancel',
                                    style: TextStyle(
                                      color: kQuizBackgroundWhite,
                                    ),
                                  ),
                                  onPressed: doneCancelFn != null
                                      ? doneCancelFn
                                      : () {
                                          Navigator.pop(context);
                                        },
                                )
                              : new Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        },
      );
    }
  }
}
