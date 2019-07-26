import 'package:sadhana/charts/model/streak.dart';
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

      //This Month Total
      if (Constant.today.month == sadhanaDate.month) monthTotal++;

      //Score Calculation
      if (sadhanaDate.isAfter(scoreStartDate)) {
        if (sadhana.isActivityDone(activity)) counter++;
      }

      //Count Calculation
      if (sadhana.isActivityDone(activity)) {
        groupBy<DateTime>(countByMonth, DateTime(sadhanaDate.year, sadhanaDate.month));
        groupBy<DateTime>(countByYear, DateTime(sadhanaDate.year));
        groupBy<DateTime>(countByWeek, getStartWeekDay(sadhanaDate)); // Start with Mon
        groupBy<DateTime>(countByQuarter, getStartQuarterDay(sadhanaDate));
      }
      if (sadhanaValue > 0) {
        if (sadhana.isNumeric) {
          countByDay[sadhanaDate] = sadhanaValue;
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
    statistics.countByMMonthWithoutMissing = Map.from(countByMonth);
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

  static addMissingValues(bool isNumeric, SadhanaStatistics statistics) {
    DateTime tmp = statistics.firstSadhanaDate;
    DateTime first = DateTime(tmp.year, tmp.month, tmp.day);
    
    DateTime today = Constant.today;
    addMissingGeneric(
      counts: statistics.countByMonth,
      firstMonth: DateTime(first.year, first.month),
      currentMonth: DateTime(today.year, today.month),
      getNext: (current) => DateTime(current.year, current.month + 1),
    );
    addMissingGeneric(
      counts: statistics.countByYear,
      firstMonth: DateTime(first.year),
      currentMonth: DateTime(today.year),
      getNext: (current) => DateTime(current.year + 1),
    );
    addMissingGeneric(
      counts: statistics.countByWeek,
      firstMonth: getStartWeekDay(first),
      currentMonth: getStartWeekDay(today),
      getNext: (current) => DateTime(current.year, current.month, current.day + 7),
    );
    addMissingGeneric(
      counts: statistics.countByWeek,
      firstMonth: getStartQuarterDay(first),
      currentMonth: getStartQuarterDay(today),
      getNext: (current) => DateTime(current.year, current.month + 3,),
    );
    if(isNumeric) {
      addMissingGeneric(
        counts: statistics.countByDay,
        firstMonth: today.add(Duration(days: -30)),
        currentMonth: today,
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

  static addMissingGeneric({Map<DateTime, int> counts, DateTime firstMonth, DateTime currentMonth, Function(DateTime) getNext}) {
    while (firstMonth != currentMonth) {
      if (counts[firstMonth] == null) counts[firstMonth] = 0;
      firstMonth = getNext(firstMonth);
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
