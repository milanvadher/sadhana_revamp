import 'package:intl/intl.dart';

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