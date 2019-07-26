//import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/charts/custom_bar_label_decorator.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/sadhana_statistics.dart';
import 'package:flutter/painting.dart' as FlutterColor;

import 'model/filter_type.dart';

class TotalStatisticsBarChart extends StatefulWidget {
  final Color color;
  final bool isNumeric;
  final SadhanaStatistics statistics;
  final bool forHistory;
  TotalStatisticsBarChart(this.statistics, this.color, {this.forHistory = false, this.isNumeric = false});

  @override
  _TotalStatisticsBarChartState createState() => _TotalStatisticsBarChartState();
}

class _TotalStatisticsBarChartState extends State<TotalStatisticsBarChart> {
  List<Series<dynamic, String>> seriesList;
  OrdinalViewport viewport;
  FilterType inputType = FilterType.Month;
  int maxValue = 0;
  Brightness theme;
  Color outSideLabelColor;
  @override
  void initState() {
    super.initState();
    if (widget.forHistory) inputType = FilterType.Day;
    generateSeriesList();
  }

  generateSeriesList() {
    List<TimeSeries> listOfTimeSeries = List();
    Map<DateTime, int> counts = widget.statistics.getCounts(inputType);
    counts.forEach((month, value) {
      listOfTimeSeries.add(TimeSeries(month, value));
    });
    listOfTimeSeries.sort((a, b) => b.time.compareTo(a.time));
    List<String> listOfXaxis = [];
    List<BarData> barChartData = [];
    for (int i = 0; i < listOfTimeSeries.length; i++) {
      TimeSeries timeSeries = listOfTimeSeries[i];
      DateTime date = timeSeries.time;
      String xaxis = getXAxis(date);
      if (i != 0) {
        if (listOfXaxis.contains(xaxis)) {
          xaxis = "$xaxis ";
        }
        xaxis = getAppendedXAxis(xaxis, date, listOfTimeSeries[i - 1].time);
      }
      listOfXaxis.add(xaxis);
      if (maxValue < timeSeries.value) maxValue = timeSeries.value;
      barChartData.add(BarData(xaxis, timeSeries.value, timeSeries.time));
    }
    List<BarData> finalBarChartData = barChartData.reversed.toList();
    viewport = OrdinalViewport(finalBarChartData.last.xAxis, 8);
    seriesList = [
      new Series<BarData, String>(
        id: 'Sadhana',
        keyFn: (value, _) => value.time.toString(),
        colorFn: (_, __) => Color.fromHex(code: widget.color.hexString),
        domainFn: (BarData sales, _) => sales.xAxis,
        measureFn: (BarData sales, _) => sales.yAxis,
        labelAccessorFn: (BarData sales, _) => sales.yAxis == 0 ? '' : sales.yAxis.toString(),
        data: finalBarChartData,
      )
    ];
  }

  getXAxis(DateTime date) {
    switch (inputType) {
      case FilterType.Month:
        return Constant.monthName[date.month - 1];
      case FilterType.Year:
        return DateFormat.y().format(date);
      case FilterType.Week:
        return DateFormat.d().format(date);
      case FilterType.Quarter:
        return Constant.monthName[date.month - 1];
      case FilterType.Day:
        return DateFormat.d().format(date);
      /*default:
        return Constant.monthName[date.month - 1];*/
    }
  }

  String getAppendedXAxis(String xaxis, DateTime date, DateTime previousDate) {
    if (inputType != FilterType.Year) {
      if (previousDate.year != date.year) {
        int year = int.parse(DateFormat("yy").format(date));
        xaxis = '$xaxis $year';
      }
    }
    if (inputType == FilterType.Week || inputType == FilterType.Day) {
      if (previousDate.month != date.month) {
        String month = Constant.monthName[date.month - 1];
        xaxis = '$xaxis $month';
      }
    }

    return xaxis;
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    outSideLabelColor = theme == Brightness.light ? Color.black : Color.white;
    return Column(
      children: <Widget>[
        buildTitle(),
        SizedBox(
          height: 240,
          child: buildBarChart(),
        )
      ],
    );
  }

  buildTitle() {
    return ListTile(
      dense: true,
      title: Text(widget.forHistory ? 'History' : 'Total', style: TextStyle(color: getFlutterColor(widget.color), fontSize: 18)),
      trailing: !widget.forHistory
          ? SizedBox(
              width: 80,
              child: buildTotalTypeDropDown(),
            )
          : null,
    );
  }

  FlutterColor.Color getFlutterColor(Color color) {
    return FlutterColor.Color.fromARGB(color.a, color.r, color.g, color.b);
  }

  buildTotalTypeDropDown() {
    Map<String, dynamic> valuesByLabel = new Map.fromIterable(FilterType.values, key: (v) => FilterTypeLabel[v], value: (v) => v);
    if(!widget.isNumeric) valuesByLabel.remove("Day");
    return DropdownButton<dynamic>(
      isExpanded: true,
      isDense: true,
      hint: Text('Select Type'),
      items: getDropDownMenuItem(valuesByLabel),
      onChanged: (value) {
        setState(() {
          inputType = value;
          generateSeriesList();
        });
      },
      value: inputType,
    );
  }

  List<DropdownMenuItem> getDropDownMenuItem(Map<String, dynamic> valuesByLabel) {
    List<DropdownMenuItem> items = [];
    if (valuesByLabel != null) {
      valuesByLabel.forEach((label, value) {
        items.add(DropdownMenuItem<dynamic>(value: value, child: new Text(label)));
      });
    }
    return items;
  }

  buildBarChart() {
    return BarChart(
      seriesList,
      animate: false,
      domainAxis: new OrdinalAxisSpec(
        tickProviderSpec: charts.BasicOrdinalTickProviderSpec(),
        renderSpec: new SmallTickRendererSpec(
          labelStyle: new TextStyleSpec(
            fontSize: 12,
            color: widget.color,
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
              color: widget.color,
            ),
            lineStyle: new LineStyleSpec(
              color: MaterialPalette.gray.shade500,
            )),
        tickProviderSpec: inputType == FilterType.Day ? getDayTickProviderSpec(maxValue) : FilterTypeTickProviderSpec[inputType],
      ),
      behaviors: [
        SlidingViewport(),
        /*new ChartTitle(
          'Total',
          behaviorPosition: BehaviorPosition.top,
          titleOutsideJustification: OutsideJustification.start,
          innerPadding: 18,
          titleStyleSpec: TextStyleSpec(color: widget.color),
        ),*/
        new PanAndZoomBehavior(),
      ],
      //defaultRenderer: LineRendererConfig(includePoints: true),
      //defaultRenderer: BarLaneRendererConfig(),
      defaultRenderer: new BarRendererConfig<String>(
        strokeWidthPx: 0.3,
        barRendererDecorator: CustomBarLabelDecorator<String>(labelAnchor: CustomBarLabelAnchor.end, outsideLabelStyleSpec: new TextStyleSpec(fontSize: 12, color: outSideLabelColor)),
      ),
    );
  }
}

/// Sample time series data type.
class TimeSeries {
  final DateTime time;
  final int value;

  TimeSeries(this.time, this.value);
}

class BarData {
  final DateTime time;
  final String xAxis;
  final int yAxis;
  BarData(this.xAxis, this.yAxis, this.time);
}
