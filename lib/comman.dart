import 'package:flutter/material.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/constant/message_constant.dart';

class CommonFunction {
  static displayErrorDialog({@required BuildContext context, String msg}) {
    if (msg != null && msg.toUpperCase().contains("SOCKET")) msg = "Looks like you lost your Internet !!";
    if (msg == null) msg = MessageConstant.COMMON_ERROR_MSG;
    alertDialog(
      context: context,
      msg: msg,
      barrierDismissible: false,
    );
  }

  // common Alert dialog
  static alertDialog({
    @required BuildContext context,
    String type = 'error', // 'success' || 'error'
    String title,
    @required String msg,
    bool showDoneButton = true,
    String doneButtonText = 'Okay',
    Function doneButtonFn,
    bool barrierDismissible = true,
    bool showCancelButton = false,
    Function doneCancelFn,
    AlertDialog Function() builder,
    Widget widget,
    bool closeable = true
  }) {
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
                              doneButtonText != null ? doneButtonText : type == 'error' ? "Okeh..." : "Hooray!",
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
                                children: <Widget>[Text("Cancel", textScaleFactor: 1.2, style: TextStyle(color: kQuizBackgroundWhite))],
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
