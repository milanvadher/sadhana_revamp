import 'package:sadhana/charts/streak.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/model/sadhana_statistics.dart';

class ChartUtils {

  static final int bestStreak = 5;


  static getScore(List<Activity> activities) {
    int counter = 0;
    DateTime time = DateTime.now().add(Duration(days: -31));
    activities.forEach((activity) {
      if (activity.sadhanaDate.isAfter(time)) {
        if (activity.sadhanaValue > 0) counter++;
      }
    });
    return ((counter / 31) * 100);
  }

  static generateStatistics(Sadhana sadhana) {
    SadhanaStatistics statistics = sadhana.statistics;
    List<Activity> activities = sadhana.activitiesByDate.values.toList();
    int counter = 0;
    DateTime time = DateTime.now().add(Duration(days: -31));
    Map<DateTime, int> countByMonth = new Map();
    Map<DateTime, int> countByYear = new Map();
    Map<DateTime, int> countByWeek = new Map();
    List<DateTime> events = new List();
    List<Streak> streakList = List();
    int total = 0;
    int monthTotal = 0;
    int totalValue = 0;

    activities.sort((a, b) => a.sadhanaDate.compareTo(b.sadhanaDate));

    DateTime start = activities[0].sadhanaDate;
    for (int i = 0; i < activities.length; i++) {
      Activity activity = activities[i];

      //Event & Total & TotalValue
      if (activity.sadhanaValue > 0) {
        events.add(activity.sadhanaDate);
        total++;
        totalValue += activity.sadhanaValue;
      }

      //This Month Total
      if(Constant.today.month == activity.sadhanaDate.month)
        monthTotal++;

      //Score Calculation
      if (activity.sadhanaDate.isAfter(time)) {
        if (activity.sadhanaValue > 0) counter++;
      }

      //Count By Month Calculation
      if (activity.sadhanaValue > 0) {
        DateTime activityMonth = DateTime(activity.sadhanaDate.year, activity.sadhanaDate.month);
        if (countByMonth[activityMonth] == null) {
          countByMonth[activityMonth] = 1;
        } else {
          countByMonth[activityMonth] = countByMonth[activityMonth] + 1;
        }
      }

      //Count By Year Calculation
      if (activity.sadhanaValue > 0) {
        DateTime activityYear = DateTime(activity.sadhanaDate.year);
        if (countByYear[activityYear] == null) {
          countByYear[activityYear] = 1;
        } else {
          countByYear[activityYear] = countByYear[activityYear] + 1;
        }
      }

      //Count By Week Calculation
      if (activity.sadhanaValue > 0) {
        DateTime activityWeek = activity.sadhanaDate.subtract(new Duration(days: activity.sadhanaDate.weekday));
        if (countByWeek[activityWeek] == null) {
          countByWeek[activityWeek] = 1;
        } else {
          countByWeek[activityWeek] = countByWeek[activityWeek] + 1;
        }
      }

      //Streak Calculation (Should be At Last)
      if (i < activities.length - 1) {
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
    }

    //Streak Calculation
    Activity last = activities.last;
    Activity lastBefore;
    if (activities.length > 1) lastBefore = activities[activities.length - 2];
    if (last.sadhanaValue > 0) {
      if (lastBefore != null && lastBefore.sadhanaValue > 0 && last.sadhanaDate.difference(lastBefore.sadhanaDate).inDays == 1) {
        streakList.add(Streak(start, last.sadhanaDate));
      } else {
        streakList.add(Streak(last.sadhanaDate, last.sadhanaDate));
      }
    }

    statistics.events = events;
    statistics.countByMonth = countByMonth;
    statistics.score = ((counter / 31) * 100).toInt();
    statistics.streakList = streakList;
    statistics.total = total;
    statistics.totalValue = totalValue;
    statistics.monthTotal = monthTotal;
    statistics.countByWeek = countByWeek;
    statistics.countByYear = countByYear;
  }
}
