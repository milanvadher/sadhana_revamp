import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class AppCalendarCarousel extends StatefulWidget {
  DateTime selectedDate;
  final List<DateTime> events;

  AppCalendarCarousel({Key key, this.selectedDate, this.events}) : super(key: key);

  @override
  _AppCalendarCarouselState createState() => _AppCalendarCarouselState();
}

class _AppCalendarCarouselState extends State<AppCalendarCarousel> {
  static Color color = Colors.red;
  static Widget _eventIcon = Padding(
    padding: EdgeInsets.only(top: 23),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 2.5,
          style: BorderStyle.solid,
        ),
      ),
    ),
  );
  EventList _markedDateMap;

  @override
  Widget build(BuildContext context) {
    _markedDateMap = new EventList(
      events: Map.fromIterable(widget.events != null ? widget.events : [], key: (v) => v, value: (v) => ["E"]),
    );
    return buildDialog();
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _handleOk() {
    Navigator.pop(context, widget.selectedDate);
  }

  buildCalendar() {
    return CalendarCarousel(
      onDayPressed: (DateTime date, List events) {
        this.setState(() => widget.selectedDate = date);
      },
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      height: 350.0,
      selectedDateTime: widget.selectedDate,
      daysHaveCircularBorder: true,
      maxSelectedDate: DateTime.now(),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.grey,
      todayTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: false,
      markedDateIconBuilder: (event) {
        return _eventIcon;
      },
    );
  }

  buildDialog() {
    final Widget picker = Flexible(
      child: buildCalendar(),
    );
    final Widget actions = ButtonTheme.bar(
      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: _handleCancel,
          ),
          FlatButton(
            child: Text("OK"),
            onPressed: _handleOk,
          ),
        ],
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              picker,
              actions,
            ],
          ),
        ),
      ],
    );
  }
}

Future<DateTime> showDatePickerWithEvents(BuildContext context, DateTime selectedDate, List<DateTime> events) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(children: <Widget>[
          Builder(
            builder: (BuildContext context) => AppCalendarCarousel(
                  selectedDate: selectedDate,
                  events: events,
                ),
          )
        ]);
      });
}