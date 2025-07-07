import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    final List<SalesData> salesData = [
      SalesData('Jan', 19),
      SalesData('Feb', 25),
      SalesData('Mar', 26),
      SalesData('Apr', 29),
      SalesData('May', 37),
      SalesData('Jun', 49),
      SalesData('Jul', 60),
      SalesData('Aug', 65),
      SalesData('Sep', 62),
      SalesData('Oct', 68),
      SalesData('Nov', 72),
      SalesData('Dec', 75),
    ];

    final List<SalesData> expensesData = [
      SalesData('Jan', 58),
      SalesData('Feb', 43),
      SalesData('Mar', 39),
      SalesData('Apr', 36),
      SalesData('May', 27),
      SalesData('Jun', 30),
      SalesData('Jul', 35),
      SalesData('Aug', 38),
      SalesData('Sep', 40),
      SalesData('Oct', 42),
      SalesData('Nov', 43),
      SalesData('Dec', 45),
    ];

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
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0.5),
            plotOffset: 0,
            labelPlacement: LabelPlacement.onTicks,
            labelStyle: TextStyle(color: BizColors.colorText.getColor(context)),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: MajorGridLines(width: 0.5),
            axisLine: AxisLine(width: 0),
            labelStyle: TextStyle(color: BizColors.colorText.getColor(context)),
          ),
          title: ChartTitle(
            text: 'Half yearly sales analysis',
            textStyle: TextStyle(color: BizColors.colorText.getColor(context)),
          ),
          legend: Legend(
            isVisible: true,
            textStyle: TextStyle(color: BizColors.colorText.getColor(context)),
          ),
          tooltipBehavior: tooltipBehavior,
          crosshairBehavior: CrosshairBehavior(
            enable: true,
            lineWidth: 1,
            lineColor: BizColors.colorText.getColor(context),
            lineDashArray: [4, 4],
            activationMode: ActivationMode.longPress,
            shouldAlwaysShow: false,
          ),
          series: <SplineAreaSeries<SalesData, String>>[
            SplineAreaSeries<SalesData, String>(
              name: 'Sales',
              dataSource: salesData,
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
              dataLabelSettings: DataLabelSettings(isVisible: false),
              markerSettings: MarkerSettings(
                isVisible: true,
                width: 6,
                height: 6,
                shape: DataMarkerType.verticalLine,
              ),
              gradient: LinearGradient(
                colors: [
                  BizColors.colorGreen.getColor(context).withOpacity(0.5),
                  BizColors.colorGreenDark.getColor(context).withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            SplineAreaSeries<SalesData, String>(
              name: 'Expenses',
              dataSource: expensesData,
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales,
              dataLabelSettings: DataLabelSettings(isVisible: false),
              markerSettings: MarkerSettings(
                isVisible: true,
                width: 6,
                height: 6,
                shape: DataMarkerType.verticalLine,
              ),
              gradient: LinearGradient(
                colors: [
                  BizColors.colorOrange.getColor(context).withOpacity(0.5),
                  BizColors.colorOrangeDark.getColor(context).withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
