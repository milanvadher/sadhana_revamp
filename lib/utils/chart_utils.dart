import 'package:sadhana/charts/model/streak.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/model/sadhana_statistics.dart';

class ChartUtils {
  static final double chartTitleSize = 16;
  static final int bestStreak = 5;
  static final int maxNumberValueHistoryDays = 90;
  static final int scroeRangeDays = 31;

  static getScore(List<Activity> activities) {
    int counter = 0;
    DateTime time = DateTime.now().add(Duration(days: -scroeRangeDays));
    DateTime nextDay = CacheData.today.add(Duration(days: 1));
    activities.forEach((activity) {
      if (activity.sadhanaDate.isAfter(time) && activity.sadhanaDate.isBefore(nextDay)) {
        if (activity.sadhanaValue > 0) counter++;
      }
    });
    return ((counter / scroeRangeDays) * 100);
  }

  static generateStatistics(Sadhana sadhana) {
    SadhanaStatistics statistics = SadhanaStatistics();
    sadhana.statistics = statistics;
    DateTime nextDay = CacheData.today.add(Duration(days: 1));
    List<Activity> activities = sadhana.activitiesByDate.values.toList();
    if (activities != null && activities.isNotEmpty) {
      int counter = 0;
      DateTime maxNumberHistory = CacheData.today.add(Duration(days: -maxNumberValueHistoryDays));
      DateTime scoreStartDate = DateTime.now().add(Duration(days: -scroeRangeDays));
      List<DateTime> events = new List();
      List<Streak> streakList = List();
      int total = 0;
      int monthTotal = 0;
      int totalValue = 0;
      int monthValue = 0;

      activities.sort((a, b) => a.sadhanaDate.compareTo(b.sadhanaDate));
      statistics.firstSadhanaDate = activities[0].sadhanaDate;
      DateTime start = activities[0].sadhanaDate;
      for (int i = 0; i < activities.length; i++) {
        Activity activity = activities[i];
        final DateTime sadhanaDate = activity.sadhanaDate;
        final int sadhanaValue = activity.sadhanaValue;
        //Event & Total & TotalValue
        if (sadhanaValue > 0) {
          if (sadhana.isActivityDone(activity)) {
            events.add(sadhanaDate);
            total++;
          }
          if (CacheData.today.month == sadhanaDate.month)
            monthValue += sadhanaValue;
          totalValue += sadhanaValue;
        }

        //Score Calculation
        if (sadhanaDate.isAfter(scoreStartDate) && activity.sadhanaDate.isBefore(nextDay)) {
          if (sadhana.isActivityDone(activity)) counter++;
        }

        //Count Calculation
        if (sadhana.isActivityDone(activity)) {
          if (CacheData.today.month == sadhanaDate.month) monthTotal++;
          groupBy<DateTime>(statistics.countByMonth, DateTime(sadhanaDate.year, sadhanaDate.month));
          groupBy<DateTime>(statistics.countByYear, DateTime(sadhanaDate.year));
          groupBy<DateTime>(statistics.countByWeek, getStartWeekDay(sadhanaDate)); // Start with Mon
          groupBy<DateTime>(statistics.countByQuarter, getStartQuarterDay(sadhanaDate));
        }
        //Numeric Calculation
        if (sadhanaValue > 0 && sadhana.isNumeric) {
          if (sadhanaDate.isAfter(maxNumberHistory)) {
            statistics.valueByDay[sadhanaDate] = sadhanaValue;
          }
          groupBy<DateTime>(statistics.valueByMonth, DateTime(sadhanaDate.year, sadhanaDate.month), value: sadhanaValue);
          groupBy<DateTime>(statistics.valueByYear, DateTime(sadhanaDate.year), value: sadhanaValue);
          groupBy<DateTime>(statistics.valueByWeek, getStartWeekDay(sadhanaDate), value: sadhanaValue); // Start with Mon
          groupBy<DateTime>(statistics.valueByQuarter, getStartQuarterDay(sadhanaDate), value: sadhanaValue);
        }

        //Streak Calculation (Should be At Last)
        if (i < activities.length - 1) {
          Activity current = activities[i];
          Activity next = activities[i + 1];

          if(sadhana.isActivityDone(current) && !sadhana.isActivityDone(next)) {
            streakList.add(Streak(start, current.sadhanaDate));
          } else if(!sadhana.isActivityDone(current) && sadhana.isActivityDone(next)) {
            start = next.sadhanaDate;
          } else if(sadhana.isActivityDone(current) && sadhana.isActivityDone(next) && next.sadhanaDate.difference(current.sadhanaDate).inDays > 1) {
            streakList.add(Streak(start, current.sadhanaDate));
            start = next.sadhanaDate;
          }
        }
      }

      //Streak Calculation
      Activity last = activities.last;
      Activity lastBefore;
      if (activities.length > 1) lastBefore = activities[activities.length - 2];
      if (sadhana.isActivityDone(last)) {
        if (lastBefore != null &&  sadhana.isActivityDone(lastBefore) && last.sadhanaDate.difference(lastBefore.sadhanaDate).inDays == 1) {
          streakList.add(Streak(start, last.sadhanaDate));
        } else {
          streakList.add(Streak(last.sadhanaDate, last.sadhanaDate));
        }
      }

      statistics.events = events;
      statistics.countByMonthWithoutMissing = Map.from(statistics.countByMonth);
      statistics.score = ((counter / scroeRangeDays) * 100).toInt();
      statistics.streakList = streakList;
      statistics.total = total;
      statistics.totalValue = totalValue;
      statistics.monthTotal = monthTotal;
      statistics.monthValue = monthValue;
      addMissingValues(sadhana.isNumeric, statistics);
    }
  }

  static addMissingValues(bool isNumeric, SadhanaStatistics statistics) {
    DateTime tmp = statistics.firstSadhanaDate;
    DateTime first = DateTime(tmp.year, tmp.month, tmp.day);

    DateTime today = CacheData.today;
    addMissingGeneric(
      countMap: statistics.countByMonth,
      start: DateTime(first.year, first.month),
      end: DateTime(today.year, today.month),
      getNext: (current) => DateTime(current.year, current.month + 1),
    );
    addMissingGeneric(
      countMap: statistics.countByYear,
      start: DateTime(first.year),
      end: DateTime(today.year),
      getNext: (current) => DateTime(current.year + 1),
    );
    addMissingGeneric(
      countMap: statistics.countByWeek,
      start: getStartWeekDay(first),
      end: getStartWeekDay(today),
      getNext: (current) => DateTime(current.year, current.month, current.day + 7),
    );
    addMissingGeneric(
      countMap: statistics.countByWeek,
      start: getStartQuarterDay(first),
      end: getStartQuarterDay(today),
      getNext: (current) => DateTime(
            current.year,
            current.month + 3,
          ),
    );
    if (isNumeric) {
      addMissingGeneric(
        countMap: statistics.valueByDay,
        start: today.add(Duration(days: -maxNumberValueHistoryDays)),
        end: today,
        getNext: (current) => current.add(Duration(days: 1)),
      );
    }
  }

  static DateTime getStartWeekDay(DateTime current) {
    return current.subtract(new Duration(days: current.weekday - 1));
  }

  static DateTime getStartQuarterDay(DateTime current) {
    return DateTime(current.year, (((current.month - 1) / 3).truncate() * 3) + 1);
  }

  static addMissingGeneric({Map<DateTime, int> countMap, DateTime start, DateTime end, Function(DateTime) getNext}) {
    while (start != end) {
      if (countMap[start] == null) countMap[start] = 0;
      start = getNext(start);
    }
  }

  static void groupBy<D>(Map<D, int> counts, D key, {int value = 1}) {
    if (counts[key] == null) {
      counts[key] = value;
    } else {
      counts[key] = counts[key] + value;
    }
  }
}
