import 'package:bizcopilot_flutter/data/model/chart_model.dart';
import 'package:bizcopilot_flutter/data/model/chart_range_model.dart';
import 'package:bizcopilot_flutter/provider/forecast/forecast_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../provider/daily_reports/home_widgets_provider.dart';
import '../../static/state/sale_forecast_result_state.dart';
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
      // Provider.of<HomeWidgetsProvider>(context, listen: false).getHomeWidgets();
      Provider.of<ForecastProvider>(context, listen: false).getSaleForecast();
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
            // ForecastChart(tooltipBehavior: _tooltipBehavior),
            Consumer<ForecastProvider>(
              builder: (context, value, child) {
                return switch (value.saleResultState) {
                  SaleForecastLoadingState() => _buildLoading(),
                  SaleForecastLoadedState(data: var data) => ForecastChart(
                    tooltipBehavior: _tooltipBehavior,
                    realData:
                        data.monthlyData?.salesData
                            ?.map(
                              (e) =>
                                  ChartModel(DateTime.parse(e.x!), e.y ?? 0.0),
                            )
                            .toList(),
                    yData:
                        data.monthlyData?.forecastData
                            ?.map(
                              (e) => ChartModel(
                                DateTime.parse(e.x!),
                                e.yhat ?? 0.0,
                              ),
                            )
                            .toList(),
                    yRangeData:
                        data.monthlyData?.forecastData
                            ?.map(
                              (e) => ChartRangeModel(
                                DateTime.parse(e.x!),
                                e.yhatUpper ?? 0.0,
                                e.yhatLower ?? 0.0,
                              ),
                            )
                            .toList(),
                  ),
                  SaleForecastErrorState(error: var message) => _buildError(
                    message,
                  ),
                  _ => const SizedBox(),
                };
              },
            ),
            const SizedBox(height: 16),
            // Consumer<HomeWidgetsProvider>(
            //   builder: (context, value, child) {
            //     return switch (value.resultState) {
            //       HomeWidgetsLoadingState() => _buildLoading(),
            //       HomeWidgetsLoadedState(data: var data) => _buildLoaded(data),
            //       HomeWidgetsErrorState(error: var message) => _buildError(
            //         message,
            //       ),
            //       _ => const SizedBox(),
            //     };
            //   },
            // ),
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
  const ForecastChart({
    super.key,
    required this.tooltipBehavior,
    this.realData = const [],
    this.yData = const [],
    this.yRangeData = const [],
  });

  final TooltipBehavior tooltipBehavior;
  final List<ChartModel>? realData;
  final List<ChartModel>? yData;
  final List<ChartRangeModel>? yRangeData;

  @override
  Widget build(BuildContext context) {
    // Collect all Y values
    final allValues = [
      ...?realData?.map((e) => e.value),
      ...?yData?.map((e) => e.value),
      ...?yRangeData?.map((e) => e.lower),
      ...?yRangeData?.map((e) => e.upper),
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
            SplineRangeAreaSeries<ChartRangeModel, DateTime>(
              name: 'Upper/Lower',
              dataSource: yRangeData,
              xValueMapper: (ChartRangeModel data, _) => data.date,
              highValueMapper: (ChartRangeModel data, _) => data.upper,
              lowValueMapper: (ChartRangeModel data, _) => data.lower,
              gradient: LinearGradient(
                colors: [
                  BizColors.colorOrange.getColor(context).withOpacity(0.4),
                  BizColors.colorOrangeDark.getColor(context).withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            SplineSeries<ChartModel, DateTime>(
              name: 'Y Data',
              dataSource: yData,
              xValueMapper: (ChartModel data, _) => data.date,
              yValueMapper: (ChartModel data, _) => data.value,
              color: BizColors.colorGreen.getColor(context),
              markerSettings: MarkerSettings(isVisible: true),
            ),
            ScatterSeries<ChartModel, DateTime>(
              name: 'Real Data',
              dataSource: realData,
              xValueMapper: (ChartModel data, _) => data.date,
              yValueMapper: (ChartModel data, _) => data.value,
              color: BizColors.colorPrimary.getColor(context),
              markerSettings: MarkerSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}
