//import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/charts/custom_bar_label_decorator.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/activity.dart';

class TotalStatisticsBarChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;
  final Color color;
  final OrdinalViewport viewport;

  TotalStatisticsBarChart(this.seriesList, this.color, {this.animate, this.viewport});

  factory TotalStatisticsBarChart.forMonth(Color color, Map<DateTime, int> countByMonth) {
    List<TimeSeries> timeSeries = List();
    countByMonth.forEach((month, value) {
      timeSeries.add(TimeSeries(month, value));
    });
    timeSeries.sort((a, b) => a.time.compareTo(b.time));
    List<OrdinalSales> barChartData = timeSeries.map((timeSeries) {
      String xaxis = Constant.monthName[timeSeries.time.month - 1];
      if (xaxis == 'Dec') {
        int year = int.parse(DateFormat("yy").format(timeSeries.time));
        xaxis = 'Dec $year';
      }
      return OrdinalSales(xaxis, timeSeries.values);
    }).toList();
    OrdinalViewport viewport = OrdinalViewport(barChartData.last.year, 8);
    List<Series<dynamic, String>> chart_series = [
      new Series<OrdinalSales, String>(
        id: 'Sadhana',
        colorFn: (_, __) => Color.fromHex(code: color.hexString),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        labelAccessorFn: (OrdinalSales sales, _) => sales.sales.toString(),
        data: barChartData,
      )
    ];
    return new TotalStatisticsBarChart(
      chart_series,
      color,
      animate: false,
      viewport: viewport,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new BarChart(
      seriesList,
      animate: animate,
      domainAxis: new OrdinalAxisSpec(
        tickProviderSpec: charts.BasicOrdinalTickProviderSpec(),
        renderSpec: new SmallTickRendererSpec(
          labelStyle: new TextStyleSpec(
            fontSize: 12,
            color: color,
          ),
          lineStyle: new LineStyleSpec(
            color: MaterialPalette.gray.shade500,
          ),
        ),
        viewport: viewport,
      ),
      primaryMeasureAxis: new NumericAxisSpec(
          renderSpec: new GridlineRendererSpec(
              labelStyle: new TextStyleSpec(
                fontSize: 12,
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
      //defaultRenderer: LineRendererConfig(includePoints: true),
      //defaultRenderer: BarLaneRendererConfig(),
      defaultRenderer: new BarRendererConfig<String>(
        strokeWidthPx: 0.3,
        barRendererDecorator: CustomBarLabelDecorator<String>(labelAnchor: CustomBarLabelAnchor.end),
      ),
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
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
