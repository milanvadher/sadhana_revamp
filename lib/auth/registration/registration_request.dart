// Package import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/number-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/common.dart';
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
  bool _dadasMba;
  File iCardPhoto;

  @override
  void initState() {
    super.initState();
    if (!AppUtils.isNullOrEmpty(widget.mhtId)) {
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
    await AppUtils.askForPermission();
  }

  @override
  Widget pageToDisplay() {
    return new Scaffold(
      appBar: AppBar(title: Text('Registration Request')),
      backgroundColor: Colors.white,
      body: new Form(
        key: _formIndiaKey,
        autovalidate: _autoValidate,
        child: SafeArea(
          child: new ListView(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 10, right: 20),
            children: <Widget>[
              //_titleAndLogo(),
              _areyouMBA(),
              _dadasMba == null ? Container() : _dadasMba ? buildRequestPage() : buildNonMBA(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRadioValueChange(bool value) {
    setState(() {
      _dadasMba = value;
    });
  }

  Widget buildNonMBA() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Wrap(
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Text(
              "Currently this app is only for MBA and Sankul Bhaio",
              style: TextStyle(color: Colors.red),
              textScaleFactor: 1.2,
            ),
            RaisedButton(
              child: Text('Back', style: TextStyle(color: Colors.white)),
              elevation: 4.0,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )),
      ),
    );
  }

  Widget _areyouMBA() {
    return Column(
      children: <Widget>[
        Text("Are you part of Dada's MBA / Sankul Bhaio?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(value: false, groupValue: _dadasMba, onChanged: _handleRadioValueChange),
            Text('No', style: new TextStyle(fontSize: 16.0)),
            Radio(value: true, groupValue: _dadasMba, onChanged: _handleRadioValueChange),
            Text('Yes', style: new TextStyle(fontSize: 16.0)),
          ],
        )
      ],
    );
  }

  Widget _titleAndLogo() {
    return Column(
      children: <Widget>[
        new SizedBox(height: 25),
        Image.asset('images/logo_2.jpg', height: 100),
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

  Widget buildRequestPage() {
    return Column(
      children: <Widget>[
        NumberInput(
          isRequiredValidation: true,
          labelText: "MHT ID",
          enabled: false,
          valueText: request.mhtId,
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
        /*ImageInput(
          title: 'Mahatama I-Card',
          onImagePicked: onImagePicked,
          image: iCardPhoto,
          isRequired: true,
        ),
        SizedBox(height: 15.0),*/
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: new RaisedButton(
                child: Text('Request', style: TextStyle(color: Colors.white)),
                elevation: 4.0,
                onPressed: _submitRequest,
              ),
            ),
            new SizedBox(width: 15.0),
            new Container(
              child: new RaisedButton(
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                elevation: 4.0,
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

  void onImagePicked(File image) async {
    await CommonFunction.tryCatchAsync(context, () async {
      print('File size ${await image.length()/1024} ');
      setState(() {
        iCardPhoto = image;
      });
    });
  }

  void _submitRequest() async {
    if (_formIndiaKey.currentState.validate()) {
      _formIndiaKey.currentState.save();
      startOverlay();
      if (Platform.isAndroid)
        request.requestSource = 'Android';
      else
        request.requestSource = 'iOS';
      print('File size ${await iCardPhoto.length()/1024} ');
      request.iCardPhoto = CommonFunction.getBase64String(iCardPhoto);
      Response res = await _api.sendRequest(request);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        CommonFunction.alertDialog(
            context: context,
            msg: "We will get back to you soon after reviewing your request or You can also contact " + Constant.MBA_MAILID,
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
