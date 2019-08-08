import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/charts/streak_chart.dart';
import 'package:sadhana/charts/totalstatisticsbarchart.dart';
import 'package:sadhana/charts/totalstatisticschart.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/main.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/model/sadhana_statistics.dart';
import 'package:sadhana/notification/app_local_notification.dart';
import 'package:sadhana/utils/apputils.dart';
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
  bool isLightTheme = false;
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
    try {
      super.didChangeDependencies();
      sadhana = widget.sadhana;
      loadData();
    } catch (e, s) {
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  loadData() {
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
        iconTheme: Theme.of(context).copyWith().iconTheme.copyWith(color: theme == Brightness.light ? Colors.white : Colors.black),
        title: Text(sadhana.sadhanaName, style: TextStyle(color: theme == Brightness.light ? Colors.white : Colors.black)),
        backgroundColor: color,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: _onEditClick),
          (!sadhana.isPreloaded) ? IconButton(icon: Icon(Icons.delete), onPressed: _onDeleteClick) : Container(),
        ],
      ),
      body: SafeArea(
        child: ListView(children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _buildTopHeader(),
                buildBoxLayout(_buildOverView()),
                buildBoxLayout(
                  Column(
                    children: <Widget>[
                      _buildTitle('Best Streak'),
                      StreakChart.withStreakList(color, statistics.streakList),
                    ],
                  ),
                  isFirst: true,
                ),
                buildBoxLayout(Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: _buildTableCalendar(),
                )),
                buildBoxLayout(SizedBox(
                  height: 290.0,
                  child: TotalStatisticsBarChart(
                    statistics,
                    getChartColor(color),
                    isNumeric: sadhana.isNumeric,
                  ),
                )),
                sadhana.isNumeric
                    ? buildBoxLayout(SizedBox(
                  height: 290.0,
                  child: TotalStatisticsBarChart(
                    statistics,
                    getChartColor(color),
                    forHistory: true,
                    sadhanaName: sadhana.sadhanaName,
                  ),
                ))
                    : Container(),
                buildBoxLayout(Column(
                  children: <Widget>[
                    _buildTitle("Statistics"),
                    SizedBox(
                      height: 250.0,
                      child: TotalStatisticsChart.forMonth(getChartColor(color), statistics.countByMonthWithoutMissing),
                    )
                  ],
                )),
              ],
            ),
          )
        ]),
      ),
    );
  }

  _buildTopHeader() {
    return Card(
      elevation: 1,
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
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
          padding: EdgeInsets.only(
            left: 15,
          ),
          child: SizedBox(
            height: 40,
            //height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                      //width: 40,
                      child: CircleProgressBar(
                        backgroundColor: Colors.grey,
                        foregroundColor: color,
                        value: statistics.score / 100,
                        //displayValue: true,
                        displayValue: false,
                      ),
                    ),
                  ],
                ),
                //_buildTitleValue2(),
                getSizeBox(),
                _buildTitleValue("Score", '${statistics.score} %'),
                getSizeBox(),
                _buildTitleValue("Total", statistics.total.toString()),
                getSizeBox(),
                sadhana.isNumeric
                    ? _buildTitleValue("${AppUtils.getCountTitleForSadhana(sadhana.sadhanaName)}", statistics.totalValue.toString())
                    : Container(),
                sadhana.isNumeric ? getSizeBox() : Container(),
                _buildTitleValue("This Month", statistics.monthTotal.toString()),
                getSizeBox(),
                sadhana.isNumeric
                    ? _buildTitleValue("${AppUtils.getCountTitleForSadhana(sadhana.sadhanaName)}", statistics.monthValue.toString())
                    : Container(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildScore() {
    return Column(
      children: <Widget>[
        Container(),
        Container(
          width: 30,
          child: CircleProgressBar(
            backgroundColor: Colors.grey,
            foregroundColor: color,
            value: statistics.score / 100,
          ),
        ),
      ],
    );
  }

  Widget getSizeBox() {
    return SizedBox(width: sadhana.isNumeric ? 8 : 15);
  }

  _buildTitleValue2() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('149', textScaleFactor: 1.1, style: TextStyle(color: color)),
                    Text('days', textScaleFactor: 0.7),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: <Widget>[
                    Text('149', textScaleFactor: 1.1, style: TextStyle(color: color)),
                    Text('pages', textScaleFactor: 0.7),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2),
            Text('Total'),
          ],
        ),
      ),
    );
  }

  _buildTitleValue(String title, String value, {String hint}) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        hint != null
            ? RichText(
                text: TextSpan(
                  style: TextStyle(color: theme == Brightness.dark ? Colors.white : Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                    TextSpan(text: hint, style: TextStyle(fontSize: 6)),
                  ],
                ),
              )
            : Text(value, style: TextStyle(color: color)),
        Text(title),
      ],
    );
  }

  _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 10, bottom: 10),
      child: Row(children: <Widget>[
        Text(
          title,
          style: TextStyle(color: color, fontSize: ChartUtils.chartTitleSize),
        )
      ]),
    );
  }

  String _getReminderText() {
    return sadhana.reminderTime != null ? Constant.APP_TIME_FORMAT.format(sadhana.reminderTime) : "Off";
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
    AppLocalNotification().cancelNotification(sadhana.id);
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
      loadData();
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
                    color: _holidays.containsKey(date) ? (theme == Brightness.light ? Colors.white : Colors.black) : Colors.black),
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
                    color: _holidays.containsKey(date) ? (theme == Brightness.light ? Colors.white : Colors.black) : Colors.black),
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
