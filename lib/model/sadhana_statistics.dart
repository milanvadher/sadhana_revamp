import 'package:sadhana/charts/model/filter_type.dart';
import 'package:sadhana/charts/model/streak.dart';

class SadhanaStatistics {
  int score = 0;
  int total = 0;
  int monthTotal = 0;
  int monthValue = 0;
  int totalValue = 0;
  DateTime firstSadhanaDate;

  Map<DateTime, int> countByMonth = Map();
  Map<DateTime, int> countByMonthWithoutMissing = Map();
  Map<DateTime, int> countByYear = Map();
  Map<DateTime, int> countByWeek = Map();
  Map<DateTime, int> countByQuarter = Map();

  Map<DateTime, int> valueByDay = Map();
  Map<DateTime, int> valueByMonth = Map();
  Map<DateTime, int> valueByYear = Map();
  Map<DateTime, int> valueByWeek = Map();
  Map<DateTime, int> valueByQuarter = Map();

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
        counts = valueByDay;
        break;
      default:
        counts = countByMonth;
    }
    return counts;
  }

  Map<DateTime, int> getTotalValues(FilterType inputType) {
    Map<DateTime, int> counts;
    switch (inputType) {
      case FilterType.Month:
        counts = valueByMonth;
        break;
      case FilterType.Week:
        counts = valueByWeek;
        break;
      case FilterType.Year:
        counts = valueByYear;
        break;
      case FilterType.Quarter:
        counts = valueByQuarter;
        break;
      case FilterType.Day:
        counts = valueByDay;
        break;
      default:
        counts = valueByMonth;
    }
    return counts;
  }
}
