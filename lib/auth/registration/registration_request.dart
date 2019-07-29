// Package import
import 'package:GnanG/UI/auth/new_otp.dart';
import 'package:GnanG/UI/widgets/base_state.dart';
import 'package:GnanG/constans/appconstant.dart';
import 'package:GnanG/model/appresponse.dart';
import 'package:GnanG/model/signupsession.dart';
import 'package:GnanG/model/userinfo.dart';
import 'package:GnanG/utils/response_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../Service/apiservice.dart';
import '../../colors.dart';
import '../../common.dart';
// File import

class RegistrationRequestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RegistrationRequestPageState();
}

class RegistrationRequestPageState extends BaseState<RegistrationRequestPage> {
  final _formIndiaKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  ApiService _api = new ApiService();
  String _mhtId;
  String _mobile;
  String _center;
  String _emailId;
  String _name;

  bool _dadasMba;

  @override
  Widget pageToDisplay() {
    return new Scaffold(
      backgroundColor: kQuizSurfaceWhite,
      body: new BackgroundGredient(
        child: _indiaChangeMobilePage(),
      ),
    );
  }

  Widget _indiaChangeMobilePage() {
    return new Form(
      key: _formIndiaKey,
      autovalidate: _autoValidate,
      child: SafeArea(
        child: new ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          children: <Widget>[
            _titleAndLogo(),
            _areyouMBA(),
            _dadasMba == null ? Container() : _dadasMba ? _indiaLoginFields() : Container(
              child: Center(
                child: Text("Currently the app is only for MBA and Sankul Bhaio")
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRadioValueChange(bool value) {
    setState(() {
      _dadasMba = value;
    });
  }

  Widget _areyouMBA() {
    return Column(
      children: <Widget>[
        Text(
          "Are you part of Dada's MBA / Sankul Bhaio?"
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: false,
              groupValue: _dadasMba,
              onChanged: _handleRadioValueChange,
            ),
            new Text(
              'No',
              style: new TextStyle(fontSize: 16.0),
            ),
            Radio(
              value: true,
              groupValue: _dadasMba,
              onChanged: _handleRadioValueChange,
            ),
            new Text(
              'Yes',
              style: new TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _titleAndLogo() {
    return Column(
      children: <Widget>[
        new SizedBox(height: 15.0),
        new Column(
          children: <Widget>[
            new Image.asset(
              'images/logo1.png',
              height: 100,
            ),
            new SizedBox(height: 5.0),
            new Text(
              'Registration Request',
              textScaleFactor: 1.5,
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            )
          ],
        ),
        new SizedBox(height: 20.0),
        new Container(
//          child: TabBar(tabs: _tabs),
          decoration: BoxDecoration(
            //This is for background color
            color: Colors.white.withOpacity(0.0),
            //This is for bottom border that is needed
            border: Border(
              bottom: BorderSide(color: Colors.red, width: 0.8),
            ),
          ),
//          color: Colors.red.shade50,
        ),
        new SizedBox(height: 20.0),
      ],
    );
  }

  Widget _indiaLoginFields() {
    return Column(
      children: <Widget>[
        new AccentColorOverride(
          color: kQuizBrown900,
          child: new TextFormField(
            validator: CommonFunction.mhtIdValidation,
            decoration: InputDecoration(
              labelText: 'Mht Id',
              hintText: 'Enter Mht Id no.',
              prefixIcon: Icon(
                Icons.person_outline,
                color: kQuizBrown900,
              ),
              filled: true,
            ),
            onSaved: (String value) {
              _mhtId = value;
            },
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
        new SizedBox(height: 15.0),
        new AccentColorOverride(
          color: kQuizBrown900,
          child: new TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) return "Name is required";
            },
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter Full Name',
              prefixIcon: Icon(
                Icons.person_outline,
                color: kQuizBrown900,
              ),
              filled: true,
            ),
            onSaved: (String value) {
              _name = value;
            },
            keyboardType: TextInputType.text,
          ),
        ),
        new SizedBox(height: 15.0),
        new AccentColorOverride(
          color: kQuizBrown900,
          child: new TextFormField(
            validator: CommonFunction.mobileValidation,
            decoration: InputDecoration(
              labelText: 'Mobile no.',
              hintText: 'Enter 10 digit Mobile no.',
              prefixIcon: Icon(
                Icons.call,
                color: kQuizBrown900,
              ),
              filled: true,
            ),
            onSaved: (String value) {
              _mobile = value;
            },
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
        new SizedBox(height: 15.0),
        new AccentColorOverride(
          color: kQuizBrown900,
          child: new TextFormField(
            validator: CommonFunction.emailValidation,
            decoration: InputDecoration(
              labelText: 'Email id',
              hintText: 'Enter Email id.',
              prefixIcon: Icon(
                Icons.email,
                color: kQuizBrown900,
              ),
              filled: true,
            ),
            onSaved: (String value) {
              _emailId = value;
            },
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        new SizedBox(height: 15.0),
        new AccentColorOverride(
          color: kQuizBrown900,
          child: new TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) return "Center is required";
            },
            decoration: InputDecoration(
              labelText: 'Center',
              hintText: 'Enter Center.',
              prefixIcon: Icon(
                Icons.location_city,
                color: kQuizBrown900,
              ),
              filled: true,
            ),
            onSaved: (String value) {
              _center = value;
            },
            keyboardType: TextInputType.text,
          ),
        ),
        new SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new RaisedButton(
                child: Text(
                  'Request',
                  style: TextStyle(color: Colors.white),
                ),
                elevation: 4.0,
                padding: EdgeInsets.all(20.0),
                onPressed: _submitRequest,
              ),
            ),
            new SizedBox(width: 15.0),
            new Container(
              child: new RaisedButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                elevation: 4.0,
                padding: EdgeInsets.all(20.0),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        )
      ],
    );
  }

  void _submitRequest() async {
    if (_formIndiaKey.currentState.validate()) {
      setState(() {
        isOverlay = true;
      });
      try {
        _formIndiaKey.currentState.save();
        UserData userData = new UserData();
        userData.mhtId = int.parse(_mhtId);
        userData.email = _emailId;
        userData.center = _center;
        userData.mobile = _mobile;
        userData.name = _name;
        Response res = await _api.requestRegistration(userData: userData);
        AppResponse appResponse = ResponseParser.parseResponse(context: context, res: res);
        if (appResponse.status == 200) {
          CommonFunction.alertDialog(
              context: context,
              msg: "You will get confirmation on your mobile within 24 Hours or You can contact to " +
                  AppConstant.MBA_MAILID,
              type: "success",
              doneButtonText: "OK",
              doneButtonFn: () {
                Navigator.pushNamed(context, '/login_new');
              });
        }
      } catch (err) {
        print('CATCH :: ');
        print(err);
        CommonFunction.displayErrorDialog(
          context: context,
          msg: err.toString(),
        );
      }
      setState(() {
        isOverlay = false;
      });
    } else {
      _autoValidate = true;
    }
  }
}
