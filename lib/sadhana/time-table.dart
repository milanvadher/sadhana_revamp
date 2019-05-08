import 'package:flutter/material.dart';

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
        title: Text('Schedule Page'),
      ),
      body: SafeArea(
        child: ListView(
          children: List.generate(20, (int index) {
            return ListTile(
              title: Text('${DateTime.now()}', textScaleFactor: 1.2,),
              subtitle: Text('Timeline event'),
              leading: CircleAvatar(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${DateTime.now().day}', textScaleFactor: 0.8),
                    Text('MON', textScaleFactor: 0.5)
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
