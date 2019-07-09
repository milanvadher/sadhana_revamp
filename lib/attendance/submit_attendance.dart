import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/attendance_summary.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class SubmitAttendancePage extends StatefulWidget {
  static const String routeName = '/submit_attendance';

  @override
  _SubmitAttendancePageState createState() => _SubmitAttendancePageState();
}

class _SubmitAttendancePageState extends BaseState<SubmitAttendancePage> {
  ApiService _api = ApiService();
  List<AttendanceSummary> summary = new List();
  final GlobalKey<FormState> _submitForm = GlobalKey<FormState>();
  UserRole _userRole;
  Color textColor;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    startLoading();
    _userRole = await AppSharedPrefUtil.getUserRole();
    if (_userRole != null) {
      Response res = await _api.getAttendanceSummary(_userRole.groupName);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        summary = AttendanceSummary.fromJsonList(appResponse.data);
        print(summary);
      }
    }
    stopLoading();
  }

  @override
  Widget pageToDisplay() {
    textColor = Theme.of(context).brightness == Brightness.dark ? Colors.grey : Colors.white;

    Widget _buildCardView(AttendanceSummary data) {
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
            elevation: 5,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(data.name),
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () => setState(() => data.showRemarks = !data.showRemarks),
                      ),
                      Text('${data.percentage.toString()} %'),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                (data.percentage < 50) || data.showRemarks
                    ? Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                            child: TextInputField(
                              isRequiredValidation: true,
                              labelText: "Reason for Absent",
                              onSaved: (val) => data.lessAttendanceReason = val,
                              padding: EdgeInsets.all(0),
                              contentPadding: EdgeInsets.all(13),
                            ),
                          ),
                        ],
                      )
                    : Container()
              ],
            )),
      );
    }

    /*Widget _buildCardView(AttendanceSummary data) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Card(
          color: ((data.presentDates / data.totalAttendanceDates) * 100) < 50
              ? Colors.lightBlue.shade300
              : Colors.lightGreen.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(data.name),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () => setState(() => data.showRemarks = !data.showRemarks),
                        ),
                        Text('${((data.presentDates / data.totalAttendanceDates) * 100).toInt().toString()} %'),
                        SizedBox(width: 10)
                      ],
                    ),
                  ),
                ],
              ),
              (((data.presentDates / data.totalAttendanceDates) * 100) < 50) || data.showRemarks
                  ? Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: textColor,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: TextFormField(
                        style: TextStyle(color: Colors.red),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          // border: InputBorder.none,
                          labelText: 'Remarks',
                          hintText: 'Enter Reason for less than 50% Attendance',
                          contentPadding: EdgeInsets.all(15),
                        ),
                        validator: (val) => CommonFunction.isRequiredValidation('Remarks', val),
                        onSaved: (val) => data.lessAttendanceReason = val,
                      ),
                    ),
                  ],
                ),
              )
                  : Container()
            ],
          ),
        ),
      );
    }*/

    Widget _buildListView() {
      return Container(
        padding: EdgeInsets.only(top: 15),
        child: ListView.builder(
          itemCount: summary.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildCardView(summary[index]);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(centerTitle: true, title: Text('Submit Attendance')),
      body: Form(
        key: _submitForm,
        child: _buildListView(),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton.extended(
          onPressed: _onSubmit,
          //backgroundColor: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
          label: Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _onSubmit() async {
    if (_submitForm.currentState.validate()) {
      _submitForm.currentState.save();
      Response res = await _api.submitMontlyReport(_userRole.groupName, summary);
      print(summary);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        CommonFunction.alertDialog(context: context, msg: "Attendance submitted successfully.");
      }
    }
  }
}
