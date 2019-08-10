import 'package:charts_common/common.dart';

enum FilterType { Day, Month, Week, Quarter, Year }
const Map<FilterType, String> FilterTypeLabel = {
  FilterType.Day: "Day",
  FilterType.Month: "Month",
  FilterType.Week: "Week",
  FilterType.Year: "Year",
  FilterType.Quarter: "Quater",
};

NumericTickProviderSpec getTickProviderSpec(List<num> ticks) {
  return StaticNumericTickProviderSpec(
    List.generate(ticks.length, (index) => TickSpec<num>(ticks[index])),
  );
}

Map<FilterType, NumericTickProviderSpec> FilterTypeTickProviderSpec = {
  FilterType.Day: getDayTickProviderSpec(100),
  FilterType.Month: getTickProviderSpec([0,7,13,19,25,31]),
  FilterType.Week: getTickProviderSpec([0,1,2,3,4,5,6,7]),
  FilterType.Year: getTickProviderSpec([0,73,146,219,292,366]),
  FilterType.Quarter: getTickProviderSpec([0,19,37,56,74,92]),
};

NumericTickProviderSpec getDayTickProviderSpec(int maxValue) {
  int tick = 4;
  int inc = (maxValue / tick).round();
  if(inc == 0)
    inc = 1;
  List<TickSpec<num>> ticks = List();
  ticks.add(TickSpec<num>(0));
  int value = inc;
  while (value < (maxValue + inc)) {
    ticks.add(TickSpec<num>(value));
    value = value + inc;
  }
  return new StaticNumericTickProviderSpec(ticks);
}