import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/charts/number_history_barchart.dart';
import 'package:sadhana/charts/streak_chart.dart';
import 'package:sadhana/charts/totalstatisticsbarchart.dart';
import 'package:sadhana/charts/totalstatisticschart.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/main.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/model/sadhana_statistics.dart';
import 'package:sadhana/utils/chart_utils.dart';
import 'package:sadhana/widgets/circle_progress_bar.dart';
import 'package:sadhana/widgets/create_sadhana_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

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
  SadhanaStatistics statistics;
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
    ChartUtils.generateStatistics(sadhana);
    statistics = sadhana.statistics;
    List<DateTime> events = statistics.events;
    _holidays = new Map.fromIterable(events, key: (v) => v, value: (v) => [true]);
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    color = theme == Brightness.light ? sadhana.lColor : sadhana.dColor;
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme:
            Theme.of(context).copyWith().accentIconTheme.copyWith(color: theme == Brightness.light ? Colors.white : Colors.black),
        iconTheme:
            Theme.of(context).copyWith().iconTheme.copyWith(color: theme == Brightness.light ? Colors.white : Colors.black),
        title: Text(sadhana.sadhanaName, style: TextStyle(color: theme == Brightness.light ? Colors.white : Colors.black)),
        backgroundColor: color,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: _onEditClick),
          (!sadhana.isPreloaded) ? IconButton(icon: Icon(Icons.delete), onPressed: _onDeleteClick) : Container(),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _buildTopHeader(),
            buildBoxLayout(_buildOverView()),
            buildBoxLayout(
              StreakChart.withStreakList(color, statistics.streakList),
              isFirst: true,
            ),
            buildBoxLayout(Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: _buildTableCalendar(),
            )),
            buildBoxLayout(SizedBox(
              height: 250.0,
              child: TotalStatisticsBarChart.forMonth(getChartColor(color), statistics.countByMonth),
            )),
            buildBoxLayout(SizedBox(
              height: 250.0,
              child: TotalStatisticsChart.forMonth(getChartColor(color), statistics.countByMonth),
            )),
            sadhana.isNumeric
                ? buildBoxLayout(SizedBox(
                    height: 250.0,
                    child: NumberHistoryBarChart.withActivity(getChartColor(color), sadhana.activitiesByDate),
                  ))
                : Container(),
          ],
        ),
      ),
    );
  }

  _buildTopHeader() {
    return Card(
      elevation: 10,
      child: ListTile(
        leading: CircleAvatar(maxRadius: 0),
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
    );
  }

  buildBoxLayout(Widget child, {bool isFirst = false}) {
    return new Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
        decoration: new BoxDecoration(
          border: new Border(
            top: BorderSide(color: Colors.grey, width: 2),
            right: BorderSide(color: Colors.grey, width: 2),
            left: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        child: child);
  }

  _buildOverView() {
    return Column(
      children: <Widget>[
        _buildTitle("Overview"),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 5),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 30,
                child: CircleProgressBar(
                  backgroundColor: Colors.grey,
                  foregroundColor: color,
                  value: statistics.score / 100,
                ),
              ),
              SizedBox(width: 15),
              _buildTitleValue("Score", '${statistics.score} %'),
              SizedBox(width: 15),
              _buildTitleValue("Total", statistics.total.toString()),
              SizedBox(width: 15),
              _buildTitleValue("This Month", statistics.monthTotal.toString()),
              SizedBox(width: 15),
              sadhana.isNumeric ? _buildTitleValue("Total Value", statistics.totalValue.toString()) : Container(),
            ],
          ),
        )
      ],
    );
  }

  _buildTitleValue(String title, String value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(color: color),
        ),
        Text(title),
      ],
    );
  }

  _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(children: <Widget>[
        Text(
          title,
          style: TextStyle(color: color, fontSize: 18),
        )
      ]),
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
        title: 'Are you sure ?',
        msg: "Do you want to delete ${sadhana.sadhanaName} and its data?",
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
    return charts.Color(r: color.red, g: color.green, b: color.blue, a: color.alpha);
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
                style: TextStyle().copyWith(
                    color:
                        _holidays.containsKey(date) ? (theme == Brightness.light ? Colors.white : Colors.black) : Colors.black),
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
                style: TextStyle(
                    color:
                        _holidays.containsKey(date) ? (theme == Brightness.light ? Colors.white : Colors.black) : Colors.black),
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
