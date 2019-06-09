import 'package:flutter/material.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/model/logindatastate.dart';

class VerifyWidget extends StatefulWidget {
  final LoginState loginState;

  const VerifyWidget({Key key, this.loginState}) : super(key: key);

  @override
  _VerifyWidgetState createState() => _VerifyWidgetState();
}

class _VerifyWidgetState extends State<VerifyWidget> {
  _resendOtp() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15.0),
          child: Text('Enter Verification Code', style: TextStyle(fontSize: 25)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          alignment: Alignment.bottomLeft,
          child: TextFormField(
            initialValue: widget.loginState.otp,
            validator: CommonValidation.otpValidation,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              icon: Icon(Icons.phonelink_lock),
              border: OutlineInputBorder(),
              labelText: 'Enter OTP',
            ),
            maxLines: 1,
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: OutlineButton(
              child: Text('Resend Verification Code'),
              onPressed: _resendOtp,
            ),
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new FlatButton(
              child: new Text(
                'Mobile change request ?',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                setState(() {
                  widget.loginState.mobileChangeRequestStart = true;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
