// Package import

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/number-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/mba_center.dart';
import 'package:sadhana/model/registration_request.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class RegistrationRequestPage extends StatefulWidget {
  String mhtId;
  RegistrationRequestPage({this.mhtId});
  @override
  State<StatefulWidget> createState() => new RegistrationRequestPageState();
}

class RegistrationRequestPageState extends BaseState<RegistrationRequestPage> {
  final _formIndiaKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  ApiService _api = new ApiService();
  RegistrationRequest request = RegistrationRequest();
  List<MBACenter> centerList;

  @override
  void initState() {
    super.initState();
    if(!AppUtils.isNullOrEmpty(widget.mhtId)) {
      request.mhtId = widget.mhtId;
    }
    loadData();
  }

  loadData() async {
    startLoading();
    Response res = await _api.getCenterList();
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.status == WSConstant.SUCCESS_CODE) {
      setState(() {
        centerList = MBACenter.fromJsonList(appResponse.data);
      });
    }
    stopLoading();
  }

  @override
  Widget pageToDisplay() {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Form(
        key: _formIndiaKey,
        autovalidate: _autoValidate,
        child: SafeArea(
          child: new ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              _titleAndLogo(),
              _indiaLoginFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleAndLogo() {
    return Column(
      children: <Widget>[
        new SizedBox(height: 25),
        new Column(
          children: <Widget>[
            new Image.asset('images/logo_2.jpg', height: 100),
            new SizedBox(height: 10.0),
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
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.0),
            border: Border(
              bottom: BorderSide(color: Colors.red, width: 0.8),
            ),
          ),
        ),
        new SizedBox(height: 20.0),
      ],
    );
  }

  Widget _indiaLoginFields() {
    return Column(
      children: <Widget>[
        NumberInput(
          isRequiredValidation: true,
          labelText: "MHT ID",
          enabled: false,
          onSaved: (val) => request.mhtId = val?.toInt().toString(),
          digitOnly: true,
        ),
        TextInputField(
          isRequiredValidation: true,
          labelText: "First Name",
          onSaved: (val) => request.firstName = val,
        ),
        TextInputField(
          isRequiredValidation: true,
          labelText: "Last Name",
          onSaved: (val) => request.lastName = val,
        ),
        TextInputField(
          labelText: 'Mobile',
          valueText: request.mobile,
          textInputType: TextInputType.phone,
          onSaved: (value) => request.mobile = value,
          validation: (value) => CommonFunction.mobileValidation(value),
        ),
        TextInputField(
          isRequiredValidation: true,
          labelText: "Email",
          textInputType: TextInputType.emailAddress,
          validation: (value) => CommonFunction.emailValidation(value),
          onSaved: (val) => request.emailId = val,
        ),
        DropDownInput.fromMap(
          labelText: "Center",
          valuesByLabel: centerList != null
              ? new Map.fromIterable(centerList, key: (v) => (v as MBACenter).title, value: (v) => (v as MBACenter).name)
              : {},
          onChange: (value) {
            setState(() {
              if (value != null) request.center = value;
            });
          },
          valueText: request.center ?? "",
          isRequiredValidation: true,
        ),
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
      _formIndiaKey.currentState.save();
      startOverlay();
      Response res = await _api.sendRequest(request);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        CommonFunction.alertDialog(
            context: context,
            msg: "You will get confirmation on your mobile within 24 Hours or You can contact to " + Constant.MBA_MAILID,
            type: "success",
            doneButtonText: "OK",
            doneButtonFn: () {
              Navigator.pop(context);
              Navigator.pop(context);
            });
      }
      stopOverlay();
    }
  }
}
