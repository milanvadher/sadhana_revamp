import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/charts/totalstatisticsbarchart.dart';
import 'package:sadhana/charts/totalstatisticschart.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/main.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/widgets/create_sadhana_dialog.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:charts_flutter/flutter.dart' as charts;
DateTime now = new DateTime.now();

Map<DateTime, List<bool>> _holidays = {
  DateTime(now.year, now.month, now.day): [true],
  DateTime(now.year, now.month, now.day - 1): [false],
  DateTime(now.year, now.month, now.day + 5): [true],
  DateTime(now.year, now.month, now.day + 3): [false],
};

class SadhanaEditPage extends StatefulWidget {
  static const String routeName = '/sadhanaEdit';
  final Sadhana sadhana;
  final Function(int) onDelete;
  SadhanaEditPage({@required this.sadhana, this.onDelete});
  @override
  SadhanaEditPageState createState() => SadhanaEditPageState();
}

class SadhanaEditPageState extends State<SadhanaEditPage> with TickerProviderStateMixin {
  Sadhana sadhana;
  Brightness theme;
  Color color;
  SadhanaDAO sadhanaDAO = SadhanaDAO();
  static DateTime now = new DateTime.now();
  DateTime today = new DateTime(now.year, now.month, now.day);
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sadhana = widget.sadhana;
    List<DateTime> events = new List();
    sadhana.activitiesByDate.forEach((timeInt, activity) {
      if (activity.sadhanaValue > 0) events.add(DateTime.fromMillisecondsSinceEpoch(timeInt));
    });
    _holidays = new Map.fromIterable(events, key: (v) => v, value: (v) => [true]);
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    color = theme == Brightness.light ? sadhana.lColor : sadhana.dColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(sadhana.sadhanaName),
        backgroundColor: color,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: _onEditClick),
          (!sadhana.isPreloaded) ? IconButton(icon: Icon(Icons.delete), onPressed: _onDeleteClick) : Container(),
        ],
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
                      sadhana.description,
                      style: TextStyle(color: color),
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
                      Text(_getReminderText()),
                    ],
                  ),
                ),
              ),
            ),
            _buildTableCalendar(),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: new SizedBox(
                  height: 250.0,
                  child: TotalStatisticsChart.withActivity(getChartColor(color),sadhana.activitiesByDate.values.toList()),
                  //TotalStatisticsBarChart.withActivity(sadhana.activitiesByDate.values.toList()),
                )),
          ],
        ),
      ),
    );
  }

  String _getReminderText() {
    return sadhana.reminderTime != null ? new DateFormat(Constant.APP_TIME_FORMAT).format(sadhana.reminderTime) : "Off";
  }

  _onEditClick() {
    showDialog(
        context: context,
        builder: (_) => CreateSadhanaDialog(
              sadhana: sadhana,
              onDone: _onSadhanaEdited,
              isEditMode: true,
            ));
  }

  _onDeleteClick() {
    CommonFunction.alertDialog(
        context: context,
        msg: "Are you sure you want to delete Sadhana and all data?",
        showCancelButton: true,
        doneButtonFn: deleteSadhana);
  }

  Future<void> deleteSadhana() async {
    await sadhanaDAO.delete(sadhana.id);
    Navigator.pop(context);
    Navigator.pop(context);
    if (widget.onDelete != null) widget.onDelete(sadhana.id);
    main();
  }

  charts.Color getChartColor(Color color) {
    return charts.Color(
        r: color.red,
        g: color.green,
        b: color.blue,
        a: color.alpha);
  }

  _onSadhanaEdited(Sadhana sadhana) {
    setState(() {
      this.sadhana = sadhana;
    });
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: color),
        weekdayStyle: TextStyle(color: color),
      ),
      forcedCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      availableGestures: AvailableGestures.horizontalSwipe,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        todayColor: _holidays.containsKey(today) ? color : Colors.transparent,
        todayStyle: TextStyle().copyWith(color: Colors.black),
        weekendStyle: TextStyle().copyWith(),
        holidayStyle: TextStyle(color: Colors.red),
        outsideHolidayStyle: TextStyle(color: Colors.green),
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(color: _holidays.containsKey(date) ? Colors.white : Colors.black),
              ),
              backgroundColor: _holidays.containsKey(date) ? color : Colors.transparent,
            ),
          );
        },
        holidayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(color: Colors.white),
              ),
              backgroundColor: color,
            ),
          );
        },
      ),
      holidays: _holidays,
      headerStyle: HeaderStyle(
        formatButtonShowsNext: true,
        centerHeaderTitle: true,
        leftChevronIcon: Icon(Icons.chevron_left, color: color),
        rightChevronIcon: Icon(Icons.chevron_right, color: color),
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
