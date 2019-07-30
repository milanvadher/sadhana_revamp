import 'package:sadhana/charts/model/streak.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/model/sadhana_statistics.dart';

class ChartUtils {
  static final double chartTitleSize = 16;
  static final int bestStreak = 5;
  static final int maxNumberValueHistoryDays = 90;

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
    if (activities != null && activities.isNotEmpty) {
      int counter = 0;
      DateTime maxNumberHistory = CacheData.today.add(Duration(days: -maxNumberValueHistoryDays));
      DateTime scoreStartDate = DateTime.now().add(Duration(days: -31));
      Map<DateTime, int> countByMonth = new Map();
      Map<DateTime, int> countByYear = new Map();
      Map<DateTime, int> countByWeek = new Map();
      Map<DateTime, int> countByQuarter = new Map();
      Map<DateTime, int> countByDay = new Map();
      List<DateTime> events = new List();
      List<Streak> streakList = List();
      int total = 0;
      int monthTotal = 0;
      int totalValue = 0;

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
          totalValue += sadhanaValue;
        }

        //Score Calculation
        if (sadhanaDate.isAfter(scoreStartDate)) {
          if (sadhana.isActivityDone(activity)) counter++;
        }

        //Count Calculation
        if (sadhana.isActivityDone(activity)) {
          if (CacheData.today.month == sadhanaDate.month) monthTotal++;
          groupBy<DateTime>(countByMonth, DateTime(sadhanaDate.year, sadhanaDate.month));
          groupBy<DateTime>(countByYear, DateTime(sadhanaDate.year));
          groupBy<DateTime>(countByWeek, getStartWeekDay(sadhanaDate)); // Start with Mon
          groupBy<DateTime>(countByQuarter, getStartQuarterDay(sadhanaDate));
        }
        if (sadhanaValue > 0 && sadhana.isNumeric) {
          if (sadhanaDate.isAfter(maxNumberHistory)) {
            countByDay[sadhanaDate] = sadhanaValue;
          }
        }

        //Streak Calculation (Should be At Last)
        if (i < activities.length - 1) {
          Activity current = activities[i];
          Activity next = activities[i + 1];
          if (!sadhana.isActivityDone(current)) {
            start = next.sadhanaDate;
            continue;
          } else if (next.sadhanaDate.difference(current.sadhanaDate).inDays > 1) {
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
      if (sadhana.isActivityDone(last)) {
        if (lastBefore != null &&  sadhana.isActivityDone(lastBefore) && last.sadhanaDate.difference(lastBefore.sadhanaDate).inDays == 1) {
          streakList.add(Streak(start, last.sadhanaDate));
        } else {
          streakList.add(Streak(last.sadhanaDate, last.sadhanaDate));
        }
      }

      statistics.events = events;
      statistics.countByMonth = countByMonth;
      statistics.countByMonthWithoutMissing = Map.from(countByMonth);
      statistics.score = ((counter / 31) * 100).toInt();
      statistics.streakList = streakList;
      statistics.total = total;
      statistics.totalValue = totalValue;
      statistics.monthTotal = monthTotal;
      statistics.countByWeek = countByWeek;
      statistics.countByYear = countByYear;
      statistics.countByQuarter = countByQuarter;
      statistics.countByDay = countByDay;
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
        countMap: statistics.countByDay,
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

  static void groupBy<D>(Map<D, int> counts, D key) {
    if (counts[key] == null) {
      counts[key] = 1;
    } else {
      counts[key] = counts[key] + 1;
    }
  }
}
