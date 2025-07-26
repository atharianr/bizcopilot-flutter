import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/model/chart_model.dart';
import '../../data/model/chart_range_model.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';

class ForecastChart extends StatelessWidget {
  const ForecastChart({
    super.key,
    required this.tooltipBehavior,
    this.saleForecastData = const [],
    this.saleForecastRangeData = const [],
    this.expenseForecastData = const [],
    this.expenseForecastRangeData = const [],
  });

  final TooltipBehavior tooltipBehavior;
  final List<ChartModel>? saleForecastData;
  final List<ChartRangeModel>? saleForecastRangeData;
  final List<ChartModel>? expenseForecastData;
  final List<ChartRangeModel>? expenseForecastRangeData;

  @override
  Widget build(BuildContext context) {
    final allValues = [
      ...?saleForecastData?.map((e) => e.value),
      ...?expenseForecastData?.map((e) => e.value),
      ...?saleForecastRangeData?.map((e) => e.lower),
      ...?expenseForecastRangeData?.map((e) => e.lower),
      ...?saleForecastRangeData?.map((e) => e.upper),
      ...?expenseForecastRangeData?.map((e) => e.upper),
    ];

    final minValue =
        allValues.isNotEmpty ? allValues.reduce((a, b) => a < b ? a : b) : 0.0;
    final maxValue =
        allValues.isNotEmpty
            ? allValues.reduce((a, b) => a > b ? a : b)
            : 1000000.0;

    return Container(
      decoration: BoxDecoration(
        color: BizColors.colorBackground.getColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 0),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: DateTimeAxis(
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0.5),
            dateFormat: DateFormat('d MMM'),
            intervalType: DateTimeIntervalType.days,
            interval: 2,
            labelStyle: TextStyle(color: BizColors.colorText.getColor(context)),
          ),
          primaryYAxis: NumericAxis(
            minimum: minValue,
            maximum: maxValue,
            interval: 250000,
            majorGridLines: MajorGridLines(width: 0.5),
            axisLine: AxisLine(width: 0),
            labelStyle: TextStyle(color: BizColors.colorText.getColor(context)),
            axisLabelFormatter: (AxisLabelRenderDetails details) {
              final num value = details.value;
              final String text = '${(value / 1000).toStringAsFixed(0)}K';
              return ChartAxisLabel(text, details.textStyle);
            },
          ),
          title: ChartTitle(
            text: 'Spot the Trends, Stay Ahead',
            textStyle: BizTextStyles.bodyLargeExtraBold.copyWith(
              color: BizColors.colorText.getColor(context),
            ),
          ),
          legend: Legend(
            isVisible: true,
            textStyle: TextStyle(color: BizColors.colorText.getColor(context)),
          ),
          tooltipBehavior: tooltipBehavior,
          series: [
            // Sales
            SplineRangeAreaSeries<ChartRangeModel, DateTime>(
              name: 'Sales Range',
              dataSource: saleForecastRangeData,
              xValueMapper: (ChartRangeModel data, _) => data.date,
              highValueMapper: (ChartRangeModel data, _) => data.upper,
              lowValueMapper: (ChartRangeModel data, _) => data.lower,
              gradient: LinearGradient(
                colors: [
                  BizColors.colorGreen.getColor(context).withValues(alpha: 0.4),
                  BizColors.colorGreenDark
                      .getColor(context)
                      .withValues(alpha: 0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            SplineSeries<ChartModel, DateTime>(
              name: 'Sales',
              dataSource: saleForecastData,
              xValueMapper: (ChartModel data, _) => data.date,
              yValueMapper: (ChartModel data, _) => data.value,
              color: BizColors.colorGreen.getColor(context),
              markerSettings: MarkerSettings(isVisible: true),
            ),

            // Expense
            SplineRangeAreaSeries<ChartRangeModel, DateTime>(
              name: 'Expense Range',
              dataSource: expenseForecastRangeData,
              xValueMapper: (ChartRangeModel data, _) => data.date,
              highValueMapper: (ChartRangeModel data, _) => data.upper,
              lowValueMapper: (ChartRangeModel data, _) => data.lower,
              gradient: LinearGradient(
                colors: [
                  BizColors.colorOrange
                      .getColor(context)
                      .withValues(alpha: 0.4),
                  BizColors.colorOrangeDark
                      .getColor(context)
                      .withValues(alpha: 0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            SplineSeries<ChartModel, DateTime>(
              name: 'Expense',
              dataSource: expenseForecastData,
              xValueMapper: (ChartModel data, _) => data.date,
              yValueMapper: (ChartModel data, _) => data.value,
              color: BizColors.colorOrange.getColor(context),
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}
