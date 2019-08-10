//import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as FlutterColor;
import 'package:intl/intl.dart';
import 'package:sadhana/charts/custom_bar_label_decorator.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/sadhana_statistics.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/utils/chart_utils.dart';

import 'model/filter_type.dart';

class TotalStatisticsBarChart extends StatefulWidget {
  final Color color;
  final bool isNumeric;
  final String sadhanaName;
  final SadhanaStatistics statistics;
  final bool forHistory;

  TotalStatisticsBarChart(this.statistics, this.color, {this.forHistory = false, this.isNumeric = false, this.sadhanaName});

  @override
  _TotalStatisticsBarChartState createState() => _TotalStatisticsBarChartState();
}

class _TotalStatisticsBarChartState extends State<TotalStatisticsBarChart> {
  List<Series<dynamic, String>> seriesList;
  OrdinalViewport viewport;
  FilterType filterType = FilterType.Month;
  int maxValue = 0;
  Brightness theme;
  Color outSideLabelColor;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    //if(!widget.forHistory) {
    filterType = await AppSharedPrefUtil.getChartFilter();
    /*} else
      filterType = FilterType.Month;*/
    setState(() {
      generateSeriesList();
    });
  }

  generateSeriesList() {
    List<TimeSeries> listOfTimeSeries = List();
    Map<DateTime, int> counts;
    if (widget.forHistory)
      counts = widget.statistics.getTotalValues(filterType);
    else
      counts = widget.statistics.getCounts(filterType);

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
        xaxis = getAppendedXAxis(xaxis, date, listOfTimeSeries[i - 1].time);
        while (listOfXaxis.contains(xaxis)) {
          xaxis = "$xaxis ";
        }
      }
      listOfXaxis.add(xaxis);
      if (maxValue < timeSeries.value) maxValue = timeSeries.value;
      barChartData.add(BarData(xaxis, timeSeries.value, timeSeries.time));
    }
    List<BarData> finalBarChartData = barChartData.reversed.toList();
    if (finalBarChartData.isNotEmpty) viewport = OrdinalViewport(finalBarChartData.last.xAxis, 8);
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
    switch (filterType) {
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
    if (filterType != FilterType.Year) {
      if (previousDate.year != date.year) {
        int year = int.parse(DateFormat("yy").format(date));
        xaxis = '$xaxis $year';
      }
    }
    if (filterType == FilterType.Week || filterType == FilterType.Day) {
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
          child: seriesList != null ? buildBarChart() : Container(),
        )
      ],
    );
  }

  buildTitle() {
    return ListTile(
      dense: true,
      title: Text(widget.forHistory ? 'No of ${AppUtils.getCountTitleForSadhana(widget.sadhanaName)}' : 'No of Days',
          style: TextStyle(color: getFlutterColor(widget.color), fontSize: ChartUtils.chartTitleSize)),
      trailing: SizedBox(
        width: 80,
        child: buildTotalTypeDropDown(),
      ),
    );
  }

  FlutterColor.Color getFlutterColor(Color color) {
    return FlutterColor.Color.fromARGB(color.a, color.r, color.g, color.b);
  }

  buildTotalTypeDropDown() {
    Map<String, dynamic> valuesByLabel = new Map.fromIterable(FilterType.values, key: (v) => FilterTypeLabel[v], value: (v) => v);
    if (!widget.forHistory) valuesByLabel.remove("Day");
    return DropdownButton<dynamic>(
      isExpanded: true,
      isDense: true,
      hint: Text('Select Type'),
      items: getDropDownMenuItem(valuesByLabel),
      onChanged: (value) {
        setState(() {
          filterType = value;
          generateSeriesList();
          if (!(filterType == FilterType.Day || filterType == FilterType.Quarter))
            AppSharedPrefUtil.saveChartFilter(filterType.toString());
        });
      },
      value: filterType,
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
    return CommonFunction.tryCatchSync(context, () {
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
          tickProviderSpec: widget.forHistory ? getDayTickProviderSpec(maxValue) : FilterTypeTickProviderSpec[filterType],
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
          barRendererDecorator: CustomBarLabelDecorator<String>(
              labelAnchor: CustomBarLabelAnchor.end, outsideLabelStyleSpec: new TextStyleSpec(fontSize: 12, color: outSideLabelColor)),
        ),
      );
    });
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
