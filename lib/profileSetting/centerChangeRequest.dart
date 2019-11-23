// Package import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/number-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/center_change_request.dart';
import 'package:sadhana/model/mba_center.dart';
import 'package:sadhana/model/registration_request.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';
import 'package:intl/intl.dart';

class CenterChangeRequestPage extends StatefulWidget {
  String mhtId;

  CenterChangeRequestPage({this.mhtId});

  @override
  State<StatefulWidget> createState() => new CenterChangeRequestPageState();
}

class CenterChangeRequestPageState extends BaseState<CenterChangeRequestPage> {


  final _formIndiaKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  ApiService _api = new ApiService();
  var dateFormatter = new DateFormat(WSConstant.DATE_FORMAT);
  CenterChangeRequest request = CenterChangeRequest();
  List<MBACenter> centerList;

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
      appBar: AppBar(title: Text('Center Change Request')),
      backgroundColor: Colors.white,
      body: new Form(
        key: _formIndiaKey,
        autovalidate: _autoValidate,
        child: SafeArea(
          child: new ListView(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 10, right: 20),
            children: <Widget>[
              //_titleAndLogo(),
              // _areyouMBA(),
              buildRequestPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRequestPage() {
    return Column(
      children: <Widget>[
        TextInputField(
          isRequiredValidation: true,
          labelText: "Reason",
          onSaved: (val) => request.reason = val,
        ),
        DropDownInput.fromMap(
          labelText: "Center",
          valuesByLabel: centerList != null
              ? new Map.fromIterable(centerList, key: (v) => (v as MBACenter).title, value: (v) => (v as MBACenter).name)
              : {},
          onChange: (value) {
            setState(() {
              if (value != null) request.centerName = value;
            });
          },
          valueText: request.centerName ?? "",
          isRequiredValidation: true,
        ),
        DateInput(
          labelText: 'New Center Date',
          isRequiredValidation: true,
          isFutureAllow: true,
          selectedDate: request.startDate != null ? DateTime.parse(request.startDate) : DateTime.now(),
          selectDate: (DateTime date) {
            setState(() {
              request.startDate = dateFormatter.format(date);
            });
          },
        ),
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

  void _submitRequest() async {
    if (_formIndiaKey.currentState.validate()) {
      _formIndiaKey.currentState.save();
      startOverlay();
      Response res = await _api.centerChangeRequest(request);
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
