import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/attendance_home.dart';
import 'package:sadhana/attendance/attendance_summary.dart';
import 'package:sadhana/attendance/attendance_utils.dart';
import 'package:sadhana/attendance/model/fill_attendance_data.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/attendance/model/user_access.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/title_with_subtitle.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

import '../common.dart';
import 'model/event.dart';

class EventAttendance extends StatefulWidget {
  final bool myAttendance;
  final bool isMyAttendanceSummary;
  EventAttendance({this.myAttendance = false, this.isMyAttendanceSummary = false});
  @override
  _EventAttendanceState createState() => _EventAttendanceState();
}

class _EventAttendanceState extends BaseState<EventAttendance> {
  ApiService _api = ApiService();
  Future<List<Event>> events;
  List<Event> openEvent = [];
  List<Event> futureEvent = [];
  List<Event> pastEvent = [];
  FillAttendanceData fillAttendanceData;
  String myMhtID;
  bool isReadOnly = false;
  @override
  void initState() {
    super.initState();
    if(!widget.myAttendance) {
      UserAccess _userRole = CacheData.userAccess;
      fillAttendanceData = _userRole.fillAttendanceData;
    } else {
      CacheData.getUserProfile().then((value) => myMhtID = value.mhtId);
      if(widget.isMyAttendanceSummary)
        this.isReadOnly = true;
    }
    events = fetchEvents;
  }

  Future<List<Event>> get fetchEvents async {
    try {
      List<Event> events;
        Response res;
        if (widget.myAttendance) {
          if(widget.isMyAttendanceSummary) // Other-1 MBA Event History
            res = await _api.getMyAttendanceSummary();
          else //MBA Event
            res = await _api.getMBAEventsAttendance();
        } else //Co-ordinator Other-1 Event
          res = await _api.fetchEvents(groupName: fillAttendanceData.groupName);
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if (appResponse.isSuccess) {
          if(widget.myAttendance) {
            if(widget.isMyAttendanceSummary)
              events = Event.fromJsonList(appResponse.data['details']);
            else
              events = Event.fromJsonList(appResponse.data);
          }
          else
            events = Event.fromJsonList(appResponse.data);
          if (widget.myAttendance)
            await addAttendanceIfAbsent(events);
          else
            await addSessionIfAbsent(events);
          return events;
        } else
          throw 'Failed to load Events';
    } catch (e, s) {
      CommonFunction.displayErrorDialog(context: context, error: e.toString());
      print(e);
      print(s);
      throw 'Error to load Event';
    }
  }

  void onEventClick(Event event) {
    if(!isReadOnly) {
      if (widget.myAttendance) {
        onCheck(event);
      } else {
        if(!event.isFuture) {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => AttendanceHomePage(date: event.startDateTime, event: event),
          ))
              .then((value) {
            if (value != null) {
              setState(() {
                event.isAttendanceTaken = value;
              });
            }
          });
        }
      }
    }
  }

  List<Widget> _buildAction() {
    return <Widget>[
      PopupMenuButton<PopUpMenu>(
        onSelected: _onPopupSelected,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenu>>[
          const PopupMenuItem<PopUpMenu>(value: PopUpMenu.attendanceSummary, child: Text('Attendance Summary')),
        ],
      ),
    ];
  }

  void _onPopupSelected(PopUpMenu result) {
    switch (result) {
      case PopUpMenu.attendanceSummary:
        Navigator.pushNamed(context, AttendanceSummaryPage.routeName);
        break;
      default:
    }
  }

  Widget createEventTile({
    @required Event event,
  }) {
    return Container(
      color: !widget.myAttendance && event.isAttendanceTaken
          ? Theme.of(context).brightness == Brightness.dark ? Colors.yellow.shade600 : Colors.yellow.shade200
          : null,
      child: ListTile(
        selected: event.isAttendanceTaken,
        title: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                event.eventName ?? "",
                overflow: TextOverflow.fade,
              ),
            ),
            !widget.myAttendance && event.isAttendanceTaken
                ? CircleAvatar(
                    maxRadius: 8,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.done, color: Colors.white, size: 12),
                  )
                : Container(),
          ],
        ),
        subtitle: Text(
          event.startDate.isNotEmpty ? '${AppUtils.getAppDisplayDate(event.startDateTime)} to ${AppUtils.getAppDisplayDate(event.endDateTime)}' : '' ?? "",
          style: Theme.of(context).textTheme.caption.copyWith(color: null, fontWeight: event.isAttendanceTaken ? FontWeight.bold : FontWeight.normal),
        ),
        onTap: () {
          onEventClick(event);
        },
        trailing: getTrailing(event, event.isEditable),
      ),
    );
  }

  Widget getTrailing(Event event, bool isEditable) {
    if (widget.myAttendance) {
      return Checkbox(
        activeColor: Colors.red.shade500,
        onChanged: isEditable && !isReadOnly ? (val) => onCheck(event) : null,
        value: event.sessions.first.attendance.first.isPresent,
      );
    } else {
      return event.isAttendanceTaken && isEditable ? Icon(Icons.edit, color: Theme.of(context).accentColor) : null;
    }
  }

  void onCheck(Event event) async {
    if(!isReadOnly) {
      if (event.isEditable) {
        startOverlay();
        await CommonFunction.tryCatchAsync(context, () async {
          event.sessions.first.attendance.first.isPresent = !event.sessions.first.attendance.first.isPresent;
          event.sessions.first.attendance.first.mhtId = myMhtID;
          AppResponse appResponse = AppResponseParser.parseResponse(await _api.submitAttendanceSession(event), context: context);
          if (appResponse.isSuccess) {
            CommonFunction.alertDialog(context: context, msg: "Your attendance submitted successfully.");
            String sessionName = AttendanceUtils.getSessionName(appResponse.data);
            if (event.sessions.first.name == null) event.sessions.first.name = sessionName;
          }
        });
        stopOverlay();
      }
    }
  }


  Future<void> addSessionIfAbsent(List<Event> events) async {
    for (Event event in events) {
      AttendanceUtils.addEmptySessionIfAbsent(event);
    }
  }

  Future<void> addAttendanceIfAbsent(List<Event> events) async {
    for (Event event in events) {
      AttendanceUtils.addEmptySessionIfAbsent(event);
      Session session = event.sessions.first;
      if (session.attendance == null || session.attendance.isEmpty) {
        Attendance attendance = new Attendance();
        attendance.isPresent = false;
        attendance.mhtId = myMhtID;
        session.attendance = List();
        session.attendance.add(attendance);
        event.isAttendanceTaken = false;
      } else {
        event.isAttendanceTaken = true;
      }
    }
  }

  showEvents(String title, List<Event> eventList, {isExpanded = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: ExpansionTile(
        title: Text(title),
        leading: Icon(Icons.event),
        initiallyExpanded: isExpanded,
        children: eventList.map((e) {
          return Column(
            children: <Widget>[
              createEventTile(event: e),
              Divider(height: 0),
            ],
          );
        }).toList(),
      ),
    );
  }

  void classifyEvents(List<Event> eventList) {
    openEvent = [];
    futureEvent = [];
    pastEvent = [];
    for (Event event in eventList) {
      if (event.isEditable) {
        event.setCurrent();
        openEvent.add(event);
      } else if (event.startDateTime.isAfter(CacheData.today)) {
        event.setFuture();
        futureEvent.add(event);
      } else {
        event.setPast();
        pastEvent.add(event);
      }
    }
  }


  @override
  Widget pageToDisplay() {
    return Scaffold(
      appBar: AppBar(
        title: widget.myAttendance ? Text('Select Event') : AppTitleWithSubTitle(
          title: 'Select Event',
          subTitle: fillAttendanceData.groupTitle,
        ),
        actions: widget.myAttendance ? null : _buildAction(),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: events,
          builder: (context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                classifyEvents(snapshot.data);
                return ListView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: <Widget>[
                    showEvents('Past Events', pastEvent),
                    showEvents('Current Events', openEvent, isExpanded: true),
                    showEvents('Future Events', futureEvent),
                  ],
                );
              }
              return Center(
                child: Text('No Events available'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "${snapshot.error}",
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
