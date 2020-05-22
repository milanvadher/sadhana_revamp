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
import 'package:sadhana/model/jobinfo.dart';
import 'package:sadhana/model/mba_center.dart';
import 'package:sadhana/model/registration_request.dart';
import 'package:sadhana/profileSetting/job_info_widget.dart';
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
  bool showJobInfo = true;
  @override
  void initState() {
    super.initState();
    if (!AppUtils.isNullOrEmpty(widget.mhtId)) {
      request.mhtId = widget.mhtId;
      request.startDate = DateTime.now();
      request.setJobInfo(JobInfo());
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

  loadCenterChangeRequest() async {
    startLoading();
    Response res = await _api.getCenterChangeRequest();
    AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
    if (appResponse.status == WSConstant.SUCCESS_CODE) {
      setState(() {
        request = CenterChangeRequest.fromJson(appResponse.data);
      });
    }
    stopLoading();
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
          selectedDate: request.startDate,
          selectDate: (DateTime date) {
            setState(() {
              request.startDate = date;
            });
          },
        ),
        DropDownInput(
          labelText: "Reason",
          items: ['Job Change', 'Other'],
          onChange: (value) {
            setState(() {
              if (value != null) request.reason = value;
              if(AppUtils.equalsIgnoreCase(request.reason, "Job Change")) {

              } else {

              }
            });
          },
          valueText: request.reason,
          isRequiredValidation: true,
        ),
        TextInputField(
          isRequiredValidation: true,
          labelText: "Reason",
          onSaved: (val) => request.reason = val,
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
        ),
        showJobInfo ? JobInfoWidget(jobInfo: request.getJobInfo()) : Container(),
      ],
    );
  }

  void _submitRequest() async {
    if (_formIndiaKey.currentState.validate()) {
      _formIndiaKey.currentState.save();
      startOverlay();
      request.status = "New";
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
