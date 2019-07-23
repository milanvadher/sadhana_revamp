import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/model/activity.dart';

class StreakChart extends StatelessWidget {
  final List<Streak> streakList;
  int maxDiff = 0;
  double baseWidth = 0;
  final Color color;
  DateFormat dateFormat = DateFormat('dd MMM yy');
  StreakChart(this.streakList, this.color) {
    for (Streak streak in streakList) {
      if (maxDiff < streak.diff) {
        maxDiff = streak.diff;
      }
    }
  }

  factory StreakChart.withActivity(Color color, List<Activity> activities) {
    activities.sort((a, b) => a.sadhanaDate.compareTo(b.sadhanaDate));
    List<Streak> streakList = List();
    if (activities.isNotEmpty) {
      DateTime start = activities[0].sadhanaDate;
      for (int i = 0; i < activities.length - 1; i++) {
        Activity current = activities[i];
        Activity next = activities[i + 1];
        if (current.sadhanaValue == 0) {
          start = next.sadhanaDate;
          continue;
        } else if (next.sadhanaDate.difference(current.sadhanaDate).inDays > 1 || next.sadhanaValue <= 0) {
          streakList.add(Streak(start, current.sadhanaDate));
          start = next.sadhanaDate;
          continue;
        }
      }
      Activity last = activities.last;
      Activity lastBefore;
      if (activities.length > 1) lastBefore = activities[activities.length - 2];
      if (last.sadhanaValue > 0) {
        if (lastBefore != null &&
            lastBefore.sadhanaValue > 0 &&
            last.sadhanaDate.difference(lastBefore.sadhanaDate).inDays == 1) {
          streakList.add(Streak(start, last.sadhanaDate));
        } else {
          streakList.add(Streak(last.sadhanaDate, last.sadhanaDate));
        }
      }
    }
    print(streakList);
    streakList.sort((a, b) => b.diff.compareTo(a.diff));
    int maxStreak = 10;
    if (streakList.length - 1 < 10) maxStreak = streakList.length - 1;
    List<Streak> finalList = streakList.sublist(0, maxStreak);
    finalList.sort((a, b) => b.start.compareTo(a.start));
    return StreakChart(finalList, color);
  }
  @override
  Widget build(BuildContext context) {
    baseWidth = MediaQuery.of(context).size.width - 160;
    return Column(
      children: <Widget>[
        Row(children: <Widget>[Text("Streak")]),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: List.generate(streakList.length, (index) => buildRow(streakList[index])),
          ),
        )
      ],
    );
  }

  buildRow(Streak streak) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              dateFormat.format(streak.start),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(width: 10),
            Container(
              height: 20,
              width: baseWidth * (streak.diff / maxDiff),
              color: color,
              alignment: Alignment(0, 0),
              child: Text(streak.diff.toString()),
            ),
            SizedBox(width: 10),
            Text(dateFormat.format(streak.end)),
          ],
        ),
        SizedBox(height: 4)
      ],
    );
  }
}

class Streak {
  DateTime start;
  DateTime end;
  get diff => end.difference(start).inDays + 1;
  Streak(this.start, this.end);

  @override
  String toString() {
    String sdate = DateFormat.yMMMd().format(start);
    String edate = DateFormat.yMMMd().format(end);
    return 'Streak{start: $sdate, end: $edate}';
  }
}
