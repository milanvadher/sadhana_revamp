//import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:sadhana/model/activity.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;

class TotalStatisticsChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final Color color;

  TotalStatisticsChart(this.seriesList, this.color, {this.animate});

  factory TotalStatisticsChart.forMonth(Color color, Map<DateTime, int> countByMonth) {
    List<TimeSeries> timeSeries = List();
    countByMonth.forEach((month, value) {
      timeSeries.add(TimeSeries(month, value));
    });
    timeSeries.sort((a, b) => a.time.compareTo(b.time));
    List<charts.Series<dynamic, DateTime>> chart_series = [
      new charts.Series<TimeSeries, DateTime>(
        id: 'Sadhana',
        colorFn: (_, __) => charts.Color.fromHex(code: color.hexString),
        domainFn: (TimeSeries sales, _) => sales.time,
        measureFn: (TimeSeries sales, _) => sales.values,
        labelAccessorFn: (TimeSeries sales, _) => sales.values.toString(),
        data: timeSeries,
      )
    ];
    return new TotalStatisticsChart(
      chart_series,
      color,
      animate: false,
    );
  }

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      domainAxis: new charts.DateTimeAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
            labelStyle: new charts.TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: color,
            ),
            lineStyle: new charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shade500,
            )),
        viewport: new charts.DateTimeExtents(start: DateTime(today.year, today.month - 6), end: today),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                fontSize: 12, // size in Pts.
                color: color,
              ),
              lineStyle: new charts.LineStyleSpec(
                color: charts.MaterialPalette.gray.shade500,
              )),
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
      behaviors: [
        new charts.ChartTitle(
          'Total',
          behaviorPosition: charts.BehaviorPosition.top,
          titleOutsideJustification: charts.OutsideJustification.start,
          innerPadding: 18,
          titleStyleSpec: charts.TextStyleSpec(color: color),
        ),
        new charts.PanAndZoomBehavior(),
        /*new charts.LinePointHighlighter(
            showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.none,
            showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
            symbolRenderer: charts.RectSymbolRenderer(isSolid: true),
        ),
        new charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
        new charts.RangeAnnotation([
          new charts.LineAnnotationSegment(
            new DateTime(2019, 7, 21),
            charts.RangeAnnotationAxisType.domain,
            startLabel: 'Oct 4',
            labelPosition: AnnotationLabelPosition.margin,
          ),
        ]),*/

        //charts.RangeAnnotation([new charts.LineAnnotationSegment<num>(1, RangeAnnotationAxisType.measure)]),
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      defaultRenderer: LineRendererConfig(includePoints: true, symbolRenderer: charts.CircleSymbolRenderer(isSolid: true)),
      /*new charts.LineRendererConfig(
        includePoints: true,
        symbolRenderer: charts.CircleSymbolRenderer(isSolid: true, )
      ),*/
      selectionModels: [
        SelectionModelConfig(changedListener: (SelectionModel model) {
          if (model.hasDatumSelection) print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
        })
      ],
    );
  }
}

/// Sample time series data type.
class TimeSeries {
  final DateTime time;
  final int values;

  TimeSeries(this.time, this.values);
}
