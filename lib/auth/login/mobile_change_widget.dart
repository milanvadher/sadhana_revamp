import 'package:flutter/material.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/model/logindatastate.dart';

class ChangeMobileWidget extends StatefulWidget {
  final LoginState loginState;

  ChangeMobileWidget({Key key, this.loginState}) : super(key: key);

  @override
  _ChangeMobileWidgetState createState() => _ChangeMobileWidgetState();
}

class _ChangeMobileWidgetState extends State<ChangeMobileWidget> {
  final TextEditingController mobileChangeCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15.0),
          child: Text('Mobile Change Request', style: TextStyle(fontSize: 25)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          alignment: Alignment.bottomLeft,
          child: TextFormField(
            controller: mobileChangeCtr,
            //initialValue: loginState.mobileNo.toString(),
            validator: CommonValidation.mobileValidation,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              icon: Icon(Icons.call),
              border: OutlineInputBorder(),
              labelText: 'New Mobile Number',
            ),
            maxLines: 1,
            maxLength: 10,
            onSaved: (value) => widget.loginState.newMobile = value,
          ),
        ),
      ],
    );
  }
}