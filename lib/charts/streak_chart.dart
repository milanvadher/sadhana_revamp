import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/charts/model/streak.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/utils/chart_utils.dart';

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

  factory StreakChart.withStreakList(Color color, List<Streak> streakList) {
    streakList.sort((a, b) => b.diff.compareTo(a.diff));
    int maxStreak = ChartUtils.bestStreak;
    if (streakList.length - 1 < maxStreak) maxStreak = streakList.length - 1;
    List<Streak> finalList = streakList.sublist(0, maxStreak - 1);
    finalList.sort((a, b) => b.start.compareTo(a.start));
    return StreakChart(finalList, color);
  }

  @override
  Widget build(BuildContext context) {
    baseWidth = MediaQuery.of(context).size.width - 170;
    return Column(
      children: List.generate(streakList.length, (index) => buildRow(streakList[index])),
    );
  }

  buildRow(Streak streak) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(dateFormat.format(streak.start)),
            SizedBox(width: 5),
            Container(
              height: 20,
              width: baseWidth * (streak.diff / maxDiff),
              color: color,
              alignment: Alignment(0, 0),
              child: Text(streak.diff.toString()),
            ),
            SizedBox(width: 5),
            Text(dateFormat.format(streak.end)),
          ],
        ),
        SizedBox(height: 4)
      ],
    );
  }
}
