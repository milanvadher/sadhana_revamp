//import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/charts/custom_bar_label_decorator.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/sadhana_statistics.dart';

enum InputType { Month, Week, Year }

class TotalStatisticsBarChart extends StatefulWidget {
  final Color color;
  final SadhanaStatistics statistics;

  TotalStatisticsBarChart(
    this.statistics,
    this.color,
  );

  @override
  _TotalStatisticsBarChartState createState() => _TotalStatisticsBarChartState();
}

class _TotalStatisticsBarChartState extends State<TotalStatisticsBarChart> {
  List<Series<dynamic,String>> seriesList;
  OrdinalViewport viewport;
  InputType inputType = InputType.Month;

  @override
  void initState() {
    super.initState();
  }

  generateSeriesList() {
    List<TimeSeries> listOfTimeSeries = List();
    widget.statistics.countByMonth.forEach((month, value) {
      listOfTimeSeries.add(TimeSeries(month, value));
    });
    listOfTimeSeries.sort((a, b) => b.time.compareTo(a.time));
    List<String> listOfXaxis = [];
    List<BarData> barChartData = [];
    for(int i = 0; i < listOfTimeSeries.length; i++) {
      TimeSeries timeSeries = listOfTimeSeries[i];
      String xaxis = Constant.monthName[timeSeries.time.month - 1];
      if(i != 0) {
        if(listOfXaxis.contains(xaxis)) {
          xaxis = "$xaxis ";
        }
        TimeSeries perviousTimeSeries = listOfTimeSeries[i - 1];
        if (perviousTimeSeries.time.year != timeSeries.time.year) {
          int year = int.parse(DateFormat("yy").format(timeSeries.time));
          xaxis = '$xaxis $year';
        }
      }
      listOfXaxis.add(xaxis);
      barChartData.add(BarData(xaxis, timeSeries.values, timeSeries.time));
    }
    List<BarData> finalBarChartData = barChartData.reversed.toList();
    viewport = OrdinalViewport(barChartData.last.xAxis, 8);
    seriesList = [
      new Series<BarData, String>(
        id: 'Sadhana',
        keyFn: (value,_) => value.time.toString(),
        colorFn: (_, __) => Color.fromHex(code: widget.color.hexString),
        domainFn: (BarData sales, _) => sales.xAxis,
        measureFn: (BarData sales, _) => sales.yAxis,
        labelAccessorFn: (BarData sales, _) => sales.yAxis.toString(),
        data: finalBarChartData,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    generateSeriesList();
    return buildBarChart();
  }

  buildTitle() {
    return ListTile(
      title: Text('Total', style: TextStyle(color: Colors.grey, fontSize: 18)),
      leading: buildTotalTypeDropDown(),
    );
  }

  buildTotalTypeDropDown() {
    Map<String, dynamic> valuesByLabel =
        new Map.fromIterable(InputType.values, key: (v) => (v as InputType).toString(), value: (v) => v);
    return DropdownButton<dynamic>(
      isExpanded: true,
      isDense: true,
      hint: Text('Select Type'),
      items: getDropDownMenuItem(valuesByLabel),
      onChanged: (value) {
        setState(() {
          inputType = value;
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

class BarData {
  final DateTime time;
  final String xAxis;
  final int yAxis;
  BarData(this.xAxis, this.yAxis, this.time);
}
