import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:flutter/material.dart';
import 'package:sadhana/model/activity.dart';

class TotalStatisticsTimeBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TotalStatisticsTimeBarChart(this.seriesList, {this.animate});

  factory TotalStatisticsTimeBarChart.withActivity(List<Activity> activities) {
    Map<DateTime, int> countByMonth = new Map();
    activities.forEach((activity) {
      if (activity.sadhanaValue > 0) {
        DateTime activityMonth = DateTime(activity.sadhanaDate.year, activity.sadhanaDate.month);
        if (countByMonth[activityMonth] == null) {
          countByMonth[activityMonth] = 1;
        } else {
          countByMonth[activityMonth] = countByMonth[activityMonth] + 1;
        }
      }
    });
    List<TimeSeries> timeSeries = List();
    countByMonth.forEach((month, value) {
      timeSeries.add(TimeSeries(month, value));
    });
    timeSeries.sort((a, b) => a.time.compareTo(b.time));
    List<charts.Series<dynamic, DateTime>> chart_series = [
      new charts.Series<TimeSeries, DateTime>(
        id: 'Sadhana',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeries sales, _) => sales.time,
        measureFn: (TimeSeries sales, _) => sales.values,
        labelAccessorFn: (TimeSeries sales, _) {
          print('inside labelAccessorFun');
          return 'K';
        },
        data: timeSeries,
      )
    ];
    return new TotalStatisticsTimeBarChart(
      chart_series,
      animate: false,
    );
  }
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      domainAxis: new charts.DateTimeAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      /*domainAxis: new charts.DateTimeAxisSpec(
          viewport: new charts.DateTimeExtents(start: DateTime(today.year, today.month - 6), end: today)),*/
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec: new charts.StaticNumericTickProviderSpec(
        <charts.TickSpec<num>>[
          charts.TickSpec<num>(0),
          charts.TickSpec<num>(7),
          charts.TickSpec<num>(13),
          charts.TickSpec<num>(19),
          charts.TickSpec<num>(25),
          charts.TickSpec<num>(31),
        ],
      )),
      behaviors: [new charts.PanAndZoomBehavior()],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      defaultRenderer: new charts.BarRendererConfig<DateTime>(barRendererDecorator:charts.BarLabelDecorator<String>() ),
    );
  }
}

/// Sample time series data type.
class TimeSeries {
  final DateTime time;
  final int values;

  TimeSeries(this.time, this.values);
}
