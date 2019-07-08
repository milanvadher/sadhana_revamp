import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/attendance_summary.dart';
import 'package:sadhana/attendance/model/user_role.dart';
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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    startLoading();
    UserRole userRole = await AppSharedPrefUtil.getUserRole();
    if (userRole != null) {
      Response res = await _api.getAttendanceSummary(userRole.groupName);
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
    final Color textColor = Theme.of(context).brightness == Brightness.dark ? Colors.grey : Colors.white;
    // TODO: implement build
    cardView(AttendanceSummary data) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Card(
          color: ((data.presentDates / data.totalAttendanceDates) * 100) < 50 ? Colors.lightBlue.shade300 : Colors.lightGreen.shade300,
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
                                hintText: 'Enter Reason for 50% Attendance',
                                contentPadding: EdgeInsets.all(15),
                              ),
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
    }

    list() {
      return Container(
        padding: EdgeInsets.only(top: 15),
        child: ListView.builder(
          itemCount: summary.length,
          itemBuilder: (BuildContext context, int index) {
            return cardView(summary[index]);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(centerTitle: true, title: Text('Submit Attendance')),
      body: list(),
    );
  }
}
