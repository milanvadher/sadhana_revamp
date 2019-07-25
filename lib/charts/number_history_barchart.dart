//import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/charts/custom_bar_label_decorator.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/activity.dart';

class NumberHistoryBarChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;
  final Color color;
  final OrdinalViewport viewport;
  int maxValue = 0;
  NumberHistoryBarChart(this.seriesList, this.color, {this.animate, this.viewport, this.maxValue});

  factory NumberHistoryBarChart.withActivity(Color color, Map<int, Activity> activitiesByDate) {
    int maxValue = 0;
    DateTime startDate = Constant.today.add(Duration(days: -90));
    List<OrdinalSales> barChartData = List();
    while (startDate.millisecondsSinceEpoch <= Constant.today.millisecondsSinceEpoch) {
      String xAxis = startDate.day.toString();
      //if (startDate.day == 1) {
      xAxis = DateFormat("d MMM").format(startDate);
      //}
      int value = 0;
      Activity activity = activitiesByDate[startDate.millisecondsSinceEpoch];
      if (activity != null) {
        value = activity.sadhanaValue;
      }
      if (maxValue < value) maxValue = value;
      barChartData.add(OrdinalSales(xAxis, value));
      startDate = startDate.add(Duration(days: 1));
    }
    OrdinalViewport viewport = OrdinalViewport(barChartData.last.year, 6);
    List<Series<dynamic, String>> chart_series = [
      new Series<OrdinalSales, String>(
        id: 'Sadhana',
        colorFn: (_, __) => Color.fromHex(code: color.hexString),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        labelAccessorFn: (OrdinalSales sales, _) => sales.sales == 0 ? "" : sales.sales.toString(),
        data: barChartData,
      )
    ];
    return new NumberHistoryBarChart(
      chart_series,
      color,
      animate: false,
      viewport: viewport,
      maxValue: maxValue,
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
              fontSize: 12, // size in Pts.
              color: color,
            ),
            lineStyle: new LineStyleSpec(
              color: MaterialPalette.gray.shade500,
            )),
        tickProviderSpec: getTickProviderSpec(),
      ),
      behaviors: [
        SlidingViewport(),
        new ChartTitle(
          'History',
          behaviorPosition: BehaviorPosition.top,
          titleOutsideJustification: OutsideJustification.start,
          innerPadding: 18,
          titleStyleSpec: TextStyleSpec(color: color),
        ),
        new PanAndZoomBehavior(),
      ],
      defaultRenderer: new BarRendererConfig<String>(
        strokeWidthPx: 0.3,
        barRendererDecorator: CustomBarLabelDecorator<String>(labelAnchor: CustomBarLabelAnchor.end),
      ),
    );
  }

  NumericTickProviderSpec getTickProviderSpec() {
    int tick = 4;
    int inc = (maxValue / tick).round();
    List<TickSpec<num>> ticks = List();
    ticks.add(TickSpec<num>(0));
    int value = inc;
    while (value < (maxValue + inc)) {
      ticks.add(TickSpec<num>(value));
      value = value + inc;
    }
    return new StaticNumericTickProviderSpec(ticks);
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OrdinalSales &&
              runtimeType == other.runtimeType &&
              year == other.year &&
              sales == other.sales;

  @override
  int get hashCode =>
      year.hashCode ^
      sales.hashCode;


}
