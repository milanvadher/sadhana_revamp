import 'package:flutter/material.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';

class SubmitAttendanceModel {
  String name;
  String reason;
  int totalDays;
  int presentDays;
  bool showRemarks;

  SubmitAttendanceModel(this.name, this.presentDays, this.totalDays,
      this.reason, this.showRemarks);
}

class SubmitAttendancePage extends StatefulWidget {
  static const String routeName = '/submit_attendance';

  @override
  _SubmitAttendancePageState createState() => _SubmitAttendancePageState();
}

class _SubmitAttendancePageState extends State<SubmitAttendancePage> {
  bool showRemarks = false;
  List<SubmitAttendanceModel> data = [
    SubmitAttendanceModel('lol 01', 34, 50, 'This is Reason 01', false),
    SubmitAttendanceModel('lol 02', 10, 50, 'This is Reason 02', false),
    SubmitAttendanceModel('lol 03', 12, 50, 'This is Reason 03', false),
    SubmitAttendanceModel('lol 04', 40, 50, 'This is Reason 04', false),
    SubmitAttendanceModel('lol 05', 8, 50, 'This is Reason 05', false),
    SubmitAttendanceModel('lol 06', 22, 50, 'This is Reason 06', false),
    SubmitAttendanceModel('lol 07', 31, 50, 'This is Reason 07', false),
    SubmitAttendanceModel('lol 08', 47, 50, 'This is Reason 08', false),
    SubmitAttendanceModel('lol 09', 10, 50, 'This is Reason 08', false),
    SubmitAttendanceModel('lol 10', 39, 50, 'This is Reason 09', false),
  ];

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey
        : Colors.white;
    // TODO: implement build
    cardView(SubmitAttendanceModel data) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Card(
          color: ((data.presentDays / data.totalDays) * 100) < 50
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
                    child: Text(
                      data.name,
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.message,
                          ),
                          onPressed: () => setState(
                              () => data.showRemarks = !data.showRemarks),
                        ),
                        Text(
                          '${((data.presentDays / data.totalDays) * 100).toInt().toString()} %',
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              (((data.presentDays / data.totalDays) * 100) < 50) ||
                      data.showRemarks
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
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return cardView(data[index]);
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
