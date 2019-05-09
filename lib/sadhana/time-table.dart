import 'package:flutter/material.dart';
import 'package:sadhana/constant/constant.dart';

DateTime today = DateTime.now();
int lastDayOfMonth = DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1)).day;

class TimeTablePage extends StatefulWidget {
  static const String routeName = '/time-table';

  @override
  TimeTablePageState createState() => TimeTablePageState();
}

class TimeTablePageState extends State<TimeTablePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget home = Scaffold(
      appBar: AppBar(
        title: Text('${Constant.monthName[today.month - 1]}-${today.year} Schedule'),
      ),
      body: SafeArea(
        child: ListView(
          children: List.generate(lastDayOfMonth, (int index) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                selected: index == today.day - 1 ? true : false,
                title: Text(
                  'Title Something',
                  textScaleFactor: 1.2,
                ),
                subtitle: Text('Timeline event'),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${index + 1}',
                      textScaleFactor: 1.5,
                      style: TextStyle(color: ThemeData().copyWith().primaryColor),
                    ),
                    Text(
                      '${Constant.weekName[DateTime(today.year, today.month, index + 1).weekday - 1]}',
                      textScaleFactor: 0.6,
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );

    return home;
  }
}
