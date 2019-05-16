import 'package:flutter/material.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime now = new DateTime.now();

final Map<DateTime, List> _holidays = {
  DateTime(now.year, now.month, now.day): [true],
  DateTime(now.year, now.month, now.day - 1): [false],
  DateTime(now.year, now.month, now.day + 5): [true],
  DateTime(now.year, now.month, now.day + 3): [false],
};

class SadhanaEditPage extends StatefulWidget {
  static const String routeName = '/sadhanaEdit';

  SadhanaEditPage({this.title, this.color, this.appBarColor, this.type});

  final String title;
  final Color color;
  final Color appBarColor;
  final SadhanaType type;

  @override
  SadhanaEditPageState createState() => SadhanaEditPageState();
}

class SadhanaEditPageState extends State<SadhanaEditPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.appBarColor,
        actions: <Widget>[IconButton(icon: Icon(Icons.edit), onPressed: () {})],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: ListTile(
                  leading: CircleAvatar(
                    maxRadius: 0,
                  ),
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Have you completed ' + widget.title + '?',
                      style: TextStyle(color: widget.color),
                    ),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Icon(Icons.loop, size: 15),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Text('Everyday'),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      Icon(Icons.alarm, size: 15),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Text('11:00 PM'),
                    ],
                  ),
                ),
              ),
            ),
            _buildTableCalendar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: widget.color),
        weekdayStyle: TextStyle(color: widget.color),
      ),
      forcedCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: widget.color,
        todayColor: widget.color.withAlpha(130),
        weekendStyle: TextStyle().copyWith(),
        holidayStyle: TextStyle(color: Colors.red),
        outsideHolidayStyle: TextStyle(color: Colors.green),
      ),
      builders: CalendarBuilders(
        holidayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(color: Colors.white),
              ),
              backgroundColor: _holidays[date][0] == (widget.type == SadhanaType.BOOLEAN ? true : 0) ? Colors.green : Colors.red,
            ),
          );
        },
      ),
      holidays: _holidays,
      headerStyle: HeaderStyle(
        formatButtonShowsNext: true,
        leftChevronIcon: Icon(Icons.chevron_left, color: widget.color),
        rightChevronIcon: Icon(Icons.chevron_right, color: widget.color),
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
