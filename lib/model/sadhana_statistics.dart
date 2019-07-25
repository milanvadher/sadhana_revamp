import 'package:sadhana/charts/streak.dart';

class SadhanaStatistics {

  int score;
  int total;
  int monthTotal;
  int totalValue;
  Map<DateTime, int> countByMonth;
  Map<DateTime, int> countByYear;
  Map<DateTime, int> countByWeek;
  List<DateTime> events;
  List<Streak> streakList = List();

}