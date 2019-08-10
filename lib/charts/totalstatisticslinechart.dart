//import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:sadhana/charts/custom_bar_label_decorator.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/activity.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class TotalStatisticsLineChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;
  final Color color;
  final OrdinalViewport viewport;

  TotalStatisticsLineChart(this.seriesList, this.color, {this.animate, this.viewport});

  factory TotalStatisticsLineChart.withActivity(Color color, List<Activity> activities) {
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
    List<OrdinalSales> barChartData = timeSeries.map((timeSeries) {
      //String xaxis = Constant.monthName[timeSeries.time.month - 1];
      /*if (xaxis == 'Dec') {
        xaxis = 'Dec ${timeSeries.time.year}';
      }*/
      return OrdinalSales(timeSeries.time.millisecondsSinceEpoch, timeSeries.values);
    }).toList();
    OrdinalViewport viewport = OrdinalViewport(barChartData.last.year.toString(), barChartData.last.sales);
    List<Series<dynamic, int>> chart_series = [
      new Series<OrdinalSales, int>(
        id: 'Sadhana',
        colorFn: (_, __) => Color.fromHex(code: color.hexString),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        labelAccessorFn: (OrdinalSales sales, _) => sales.sales.toString(),
        data: barChartData,
      )
    ];
    return new TotalStatisticsLineChart(
      chart_series,
      color,
      animate: false,
      viewport: viewport,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LineChart(
      seriesList,
      animate: animate,
      /*domainAxis: new charts.NumericAxisSpec(
        viewport: new charts.NumericExtents(3.0, 7.0),
      ),
*/
      primaryMeasureAxis: new NumericAxisSpec(
          renderSpec: new GridlineRendererSpec(
              labelStyle: new TextStyleSpec(
                fontSize: 12, // size in Pts.
                color: color,
              ),
              lineStyle: new LineStyleSpec(
                color: MaterialPalette.gray.shade500,
              )),
          tickProviderSpec: new StaticNumericTickProviderSpec(
            <TickSpec<num>>[
              TickSpec<num>(0),
              TickSpec<num>(7),
              TickSpec<num>(13),
              TickSpec<num>(19),
              TickSpec<num>(25),
              TickSpec<num>(31),
            ],
          )),
      behaviors: [
        SlidingViewport(),
        new ChartTitle(
          'Total',
          behaviorPosition: BehaviorPosition.top,
          titleOutsideJustification: OutsideJustification.start,
          innerPadding: 18,
          titleStyleSpec: TextStyleSpec(color: color),
        ),
        new PanAndZoomBehavior(),
      ],
      defaultRenderer: LineRendererConfig(includePoints: true),
      //defaultRenderer: BarLaneRendererConfig(),
      /*defaultRenderer: new BarRendererConfig<String>(
        strokeWidthPx: 0.3,
        barRendererDecorator: CustomBarLabelDecorator<String>(),
      ),*/
    );
  }
}

/// Sample time series data type.
class TimeSeries {
  final DateTime time;
  final int values;

  TimeSeries(this.time, this.values);
}

class OrdinalSales {
  final int year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
