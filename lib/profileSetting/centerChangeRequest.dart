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
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/center_change_request.dart';
import 'package:sadhana/model/jobinfo.dart';
import 'package:sadhana/model/mba_center.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/model/registration_request.dart';
import 'package:sadhana/profileSetting/job_info_widget.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';
import 'package:intl/intl.dart';

class CenterChangeRequestPage extends StatefulWidget {
  CenterChangeRequestPage();

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
  bool showJobInfo = false;
  @override
  void initState() {
    super.initState();
    loadCenterList();
    loadCenterChangeRequest();
  }

  loadCenterList() async {
    startLoading();
    await CommonFunction.tryCatchAsync(context, () async {
      Profile profile = await CacheData.getUserProfile();
      request.mhtId = profile.mhtId;
      request.startDate = DateTime.now();
      Response res = await _api.getCenterList();
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.isSuccess) {
        setState(() {
          centerList = MBACenter.fromJsonList(appResponse.data);
        });
      }
    });
    stopLoading();
  }

  loadCenterChangeRequest() async {
    startLoading();
    await CommonFunction.tryCatchAsync(context, () async {
      Response res = await _api.getCenterChangeRequest();
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.isSuccess && appResponse.data != null) {
        setState(() {
          request = CenterChangeRequest.fromJson(appResponse.data);
          checkJobReason();
        });
      }
    });
    stopLoading();
  }

  @override
  Widget pageToDisplay() {
    return new Scaffold(
      appBar: AppBar(title: Text('Center Change Request')),
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
          minDate: CacheData.today.add(Duration(days: -30)),
          maxDate: CacheData.today.add(Duration(days: 30)),
          selectDate: (DateTime date) {
            setState(() {
              request.startDate = date;
            });
          },
        ),
        DropDownInput.fromMap(
          labelText: "Reason",
          valuesByLabel: {'Job/Seva Change': 'Job', 'Other': 'Other'},
          onChange: (value) {
            setState(() {
              if (value != null) request.reason = value;
              checkJobReason();
            });
          },
          valueText: request.reason,
          isRequiredValidation: true,
        ),
        showJobInfo ? JobInfoWidget(jobInfo: request.jobInfo, displayStartDate: false) : Container(),
        TextInputField(
          isRequiredValidation: true,
          labelText: "Reason Description",
          onSaved: (val) => request.description = val,
          valueText: request.description,
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
      ],
    );
  }

  void checkJobReason() {
    if (AppUtils.equalsIgnoreCase(request.reason, "Job")) {
      setState(() {
        showJobInfo = true;
      });
    }
  }

  void _submitRequest() async {
    if (_formIndiaKey.currentState.validate()) {
      _formIndiaKey.currentState.save();
      startOverlay();
      await CommonFunction.tryCatchAsync(context, () async {
        request.status = "New";
        Response res = await _api.centerChangeRequest(request);
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if (appResponse.isSuccess) {
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
      });
      stopOverlay();
    }
  }
}
