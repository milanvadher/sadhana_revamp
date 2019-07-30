import 'package:sadhana/charts/model/filter_type.dart';
import 'package:sadhana/charts/model/streak.dart';

class SadhanaStatistics {
  int score = 0;
  int total = 0;
  int monthTotal = 0;
  int totalValue = 0;
  DateTime firstSadhanaDate;
  Map<DateTime, int> countByDay = Map();
  Map<DateTime, int> countByMonth = Map();
  Map<DateTime, int> countByMonthWithoutMissing = Map();
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
