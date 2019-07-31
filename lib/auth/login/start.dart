import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/model/logindatastate.dart';

class StartWidget extends StatelessWidget {
  final LoginState loginState;

  const StartWidget({Key key, @required this.loginState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                'Enter Your I-Card Number',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Please enter Mahatma I-Card/Temporary Id (\'Z\') Number to Proceed:',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        // MHT ID
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.bottomLeft,
          child: TextFormField(
            initialValue: loginState.mhtId,
            validator: CommonValidation.mhtIdValidation,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              border: OutlineInputBorder(),
              labelText: 'Mht ID',
            ),
            onSaved: (value) => loginState.mhtId = value,
            maxLines: 1,
            maxLength: 6,
          ),
        ),
      ],
    );
  }
}
