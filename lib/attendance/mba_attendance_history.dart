import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/mba_attendance.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class MBAAttendanceHistory extends StatefulWidget {
  static const String routeName = '/mba_attendance_history';
  final String mhtID;
  final String name;
  const MBAAttendanceHistory({Key key, this.mhtID, this.name}) : super(key: key);
  @override
  _MBAAttendanceHistoryState createState() => new _MBAAttendanceHistoryState();
}

class _MBAAttendanceHistoryState extends BaseState<MBAAttendanceHistory> {
  static List<MBAAttendance> attendances;
  /*= [
    MBAAttendance.name("2019-07-10", true),
    MBAAttendance.name("2019-07-11", false),
    MBAAttendance.name("2019-07-12", true),
  ];*/
  UserRole _userRole;
  ApiService _api = ApiService();
  EventList<MBAAttendance> _markedDateMap;
  var len = 9;
  double cHeight;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    startLoading();
    try {
      _userRole = await AppSharedPrefUtil.getUserRole();
      if (_userRole != null) {
        Response res = await _api.getMBAAttendance(widget.mhtID);
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          setState(() {
            attendances = MBAAttendance.fromJsonList(appResponse.data);
            _markedDateMap = EventList(
              events: Map.fromIterable(attendances != null ? attendances : [],
                  key: (v) => (v as MBAAttendance).attendanceDate, value: (v) => [v]),
            );
          });
          print(attendances);
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopLoading();
  }

  static Widget buildIcon(MBAAttendance mbaAttendance) {
    return Container(
      decoration: BoxDecoration(
        color: mbaAttendance.isPresent ? Colors.green : Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(1000),
        ),
      ),
      child: Center(
        child: Text(
          mbaAttendance.attendanceDate.day.toString(),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }


  @override
  Widget pageToDisplay() {
    cHeight = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildCalendar(),
            markerRepresent(Colors.red, "Absent"),
            markerRepresent(Colors.green, "Present"),
          ],
        ),
      ),
    );
  }

  Widget buildCalendar() {
    return CalendarCarousel<MBAAttendance>(
      dayPadding: 0,
      weekDayMargin: EdgeInsets.only(bottom: 2),
      height: cHeight * 0.63,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      todayButtonColor: Colors.transparent,
      todayTextStyle: TextStyle(color: Colors.black),
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null, // null for not showing hidden events indicator
      markedDateIconBuilder: (event) {
        return buildIcon(event);
      },
    );
  }

  Widget markerRepresent(Color color, String data) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: 20,
      ),
      title: new Text(
        data,
      ),
    );
  }
}
