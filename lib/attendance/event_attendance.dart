import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/attendance/user_list.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/appsharedpref.dart';

import '../common.dart';
import 'model/event.dart';

class EventAttendance extends StatefulWidget {
  @override
  _EventAttendanceState createState() => _EventAttendanceState();
}

class _EventAttendanceState extends State<EventAttendance> {
  ApiService _api = ApiService();
  Future<List<Event>> futureEvent;

  void onEventClick(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserList(event: event),
      ),
    );
  }

  Widget createEventTile({
    @required Event event,
  }) {
    return Container(
      color: event.isAttendanceTaken
          ? Theme.of(context).brightness == Brightness.dark
              ? Colors.yellow.shade600
              : Colors.yellow.shade200
          : null,
      child: ListTile(
        selected: event.isAttendanceTaken,
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(event.eventName ?? ""),
            ),
            event.isAttendanceTaken
                ? CircleAvatar(
                    maxRadius: 8,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 12,
                    ),
                  )
                : Container(),
          ],
        ),
        subtitle: Text(
          event.startDate.isNotEmpty
              ? '${event.startDate} to ${event?.endDate}'
              : '' ?? "",
          style: Theme.of(context).textTheme.caption.copyWith(
                color: event.isAttendanceTaken
                    ? Theme.of(context).primaryColor.withAlpha(150)
                    : null,
              ),
        ),
        onTap: () {
          onEventClick(event);
        },
        trailing: event.isAttendanceTaken
            ? Icon(
                Icons.edit,
                color: Theme.of(context).accentColor,
              )
            : null,
      ),
    );
  }

  Future<List<Event>> get fetchEvents async {
    try {
      UserRole _userRole = await AppSharedPrefUtil.getUserRole();
      if (_userRole != null) {
        Response res = await _api.fetchEvents(groupName: _userRole.groupName);
        if (res.statusCode == WSConstant.SUCCESS_CODE) {
          return EventResponse.fromJson(jsonDecode(res.body)).message;
        }
        throw 'Failed to load Events';
      }
      throw 'Insufficient permission';
    } catch (e) {
      CommonFunction.displayErrorDialog(context: context);
      throw 'Error to load Event';
    }
  }

  @override
  void initState() {
    super.initState();
    futureEvent = fetchEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Event'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: futureEvent,
          builder: (context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (context, int index) {
                  return Divider(height: 0);
                },
                itemBuilder: (context, int index) {
                  Event event = snapshot.data[index];
                  return createEventTile(event: event);
                },
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
