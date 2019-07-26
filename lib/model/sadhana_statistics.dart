import 'package:sadhana/charts/model/filter_type.dart';
import 'package:sadhana/charts/model/streak.dart';

class SadhanaStatistics {
  int score;
  int total;
  int monthTotal;
  int totalValue;
  DateTime firstSadhanaDate;
  Map<DateTime, int> countByDay = Map();
  Map<DateTime, int> countByMonth = Map();
  Map<DateTime, int> countByMMonthWithoutMissing = Map();
  Map<DateTime, int> countByYear = Map();
  Map<DateTime, int> countByWeek = Map();
  Map<DateTime, int> countByQuarter = Map();
  List<DateTime> events = List();
  List<Streak> streakList = List();

  Map<DateTime, int> getCounts(FilterType inputType) {
    Map<DateTime, int> counts;
    switch (inputType) {
      case FilterType.Month:
        counts = countByMonth;
        break;
      case FilterType.Week:
        counts = countByWeek;
        break;
      case FilterType.Year:
        counts = countByYear;
        break;
      case FilterType.Quarter:
        counts = countByQuarter;
        break;
      case FilterType.Day:
        counts = countByDay;
        break;
      default:
        counts = countByMonth;
    }
    return counts;
  }
}
