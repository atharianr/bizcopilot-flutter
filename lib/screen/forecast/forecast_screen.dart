import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../provider/daily_reports/home_widgets_provider.dart';
import '../../static/state/home_widgets_result_state.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';
import '../widget/forecast_gradient_card.dart';
import '../widget/shimmer_card.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeWidgetsProvider>(context, listen: false).getHomeWidgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.colorBackground.getColor(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<HomeWidgetsProvider>(
            context,
            listen: false,
          ).getHomeWidgets();
        },
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Text(
              "Gain insights into your business future.",
              style: BizTextStyles.titleLargeBold.copyWith(
                color: BizColors.colorText.getColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Powered by Artificial Intelligence",
                  style: BizTextStyles.bodyLargeMedium.copyWith(
                    color: BizColors.colorText.getColor(context),
                  ),
                ),
                const SizedBox(width: 6),
                SvgPicture.asset(
                  'assets/images/ic_artificial_intelligence_white_12.svg',
                  width: 10,
                  height: 10,
                  colorFilter: ColorFilter.mode(
                    BizColors.colorBlack.getColor(context),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ForecastChart(tooltipBehavior: _tooltipBehavior),
            const SizedBox(height: 16),
            Consumer<HomeWidgetsProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  HomeWidgetsLoadingState() => _buildLoading(),
                  HomeWidgetsLoadedState(data: var data) => _buildLoaded(data),
                  HomeWidgetsErrorState(error: var message) => _buildError(
                    message,
                  ),
                  _ => const SizedBox(),
                };
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        ShimmerCard(),
        const SizedBox(height: 16),
        ShimmerCard(),
        const SizedBox(height: 16),
        ShimmerCard(),
      ],
    );
  }

  Widget _buildLoaded(List<dynamic> data) {
    return Column(
      children: [
        ForecastGradientCard(
          colors: [
            BizColors.colorPrimary.getColor(context),
            BizColors.colorPrimaryDark.getColor(context),
          ],
          title: "Predict Your Profits",
          content: data[0].forecast ?? "-",
        ),
        const SizedBox(height: 16),
        ForecastGradientCard(
          colors: [
            BizColors.colorGreen.getColor(context),
            BizColors.colorGreenDark.getColor(context),
          ],
          title: "Future Sales Insights",
          content: data[1].forecast ?? "-",
        ),
        const SizedBox(height: 16),
        ForecastGradientCard(
          colors: [
            BizColors.colorOrange.getColor(context),
            BizColors.colorOrangeDark.getColor(context),
          ],
          title: "Upcoming Cost Trends",
          content: data[2].forecast ?? "-",
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: BizColors.colorText.getColor(context)),
      ),
    );
  }
}

class ForecastChart extends StatelessWidget {
  const ForecastChart({super.key, required this.tooltipBehavior});

  final TooltipBehavior tooltipBehavior;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> realData = [
      ChartData(DateTime(2024, 7, 1), 1650000),
      ChartData(DateTime(2024, 7, 4), 2400000),
      ChartData(DateTime(2024, 7, 7), 1850000),
      ChartData(DateTime(2024, 7, 10), 3100000),
      ChartData(DateTime(2024, 7, 13), 2000000),
      ChartData(DateTime(2024, 7, 16), 2800000),
      ChartData(DateTime(2024, 7, 19), 1900000),
      ChartData(DateTime(2024, 7, 22), 3250000),
      ChartData(DateTime(2024, 7, 25), 2100000),
      ChartData(DateTime(2024, 7, 28), 2950000),
    ];

    final List<ChartData> yData = [
      ChartData(DateTime(2024, 7, 1), 1750000),
      ChartData(DateTime(2024, 7, 4), 2500000),
      ChartData(DateTime(2024, 7, 7), 1950000),
      ChartData(DateTime(2024, 7, 10), 3200000),
      ChartData(DateTime(2024, 7, 13), 2100000),
      ChartData(DateTime(2024, 7, 16), 2900000),
      ChartData(DateTime(2024, 7, 19), 2000000),
      ChartData(DateTime(2024, 7, 22), 3350000),
      ChartData(DateTime(2024, 7, 25), 2200000),
      ChartData(DateTime(2024, 7, 28), 3050000),
    ];

    final List<RangeData> yRangeData = [
      RangeData(DateTime(2024, 7, 1), 1500000, 2000000),
      RangeData(DateTime(2024, 7, 4), 2200000, 2700000),
      RangeData(DateTime(2024, 7, 7), 1700000, 2200000),
      RangeData(DateTime(2024, 7, 10), 3000000, 3500000),
      RangeData(DateTime(2024, 7, 13), 1900000, 2400000),
      RangeData(DateTime(2024, 7, 16), 2700000, 3200000),
      RangeData(DateTime(2024, 7, 19), 1800000, 2300000),
      RangeData(DateTime(2024, 7, 22), 3100000, 3600000),
      RangeData(DateTime(2024, 7, 25), 2000000, 2500000),
      RangeData(DateTime(2024, 7, 28), 2800000, 3300000),
    ];

    // Collect all Y values
    final allValues = [
      ...realData.map((e) => e.value),
      ...yData.map((e) => e.value),
      ...yRangeData.map((e) => e.lower),
      ...yRangeData.map((e) => e.upper),
    ];

    // Find min and max
    final minValue = allValues.reduce((a, b) => a < b ? a : b);
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);

    return Container(
      decoration: BoxDecoration(
        color: BizColors.colorBackground.getColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
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
            SplineRangeAreaSeries<RangeData, DateTime>(
              name: 'Upper/Lower',
              dataSource: yRangeData,
              xValueMapper: (RangeData data, _) => data.date,
              highValueMapper: (RangeData data, _) => data.upper,
              lowValueMapper: (RangeData data, _) => data.lower,
              gradient: LinearGradient(
                colors: [
                  BizColors.colorOrange.getColor(context).withOpacity(0.4),
                  BizColors.colorOrangeDark.getColor(context).withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            SplineSeries<ChartData, DateTime>(
              name: 'Y Data',
              dataSource: yData,
              xValueMapper: (ChartData data, _) => data.date,
              yValueMapper: (ChartData data, _) => data.value,
              color: BizColors.colorGreen.getColor(context),
              markerSettings: MarkerSettings(isVisible: true),
            ),
            ScatterSeries<ChartData, DateTime>(
              name: 'Real Data',
              dataSource: realData,
              xValueMapper: (ChartData data, _) => data.date,
              yValueMapper: (ChartData data, _) => data.value,
              color: BizColors.colorPrimary.getColor(context),
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.date, this.value);

  final DateTime date;
  final double value;
}

class RangeData {
  RangeData(this.date, this.lower, this.upper);

  final DateTime date;
  final double lower;
  final double upper;
}
