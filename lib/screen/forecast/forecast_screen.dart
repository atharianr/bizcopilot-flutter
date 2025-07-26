import 'package:bizcopilot_flutter/data/model/chart_model.dart';
import 'package:bizcopilot_flutter/data/model/chart_range_model.dart';
import 'package:bizcopilot_flutter/provider/forecast/forecast_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../static/state/expense_forecast_result_state.dart';
import '../../static/state/sale_forecast_result_state.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';
import '../widget/forecast_chart.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ForecastProvider>(context, listen: false).getSaleForecast();
      Provider.of<ForecastProvider>(
        context,
        listen: false,
      ).getExpenseForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saleResultState = context.watch<ForecastProvider>().saleResultState;
    final saleForecastData =
        saleResultState is SaleForecastLoadedState
            ? saleResultState.listData
            : <ChartModel>[];
    final saleForecastRangeData =
        saleResultState is SaleForecastLoadedState
            ? saleResultState.listRangeData
            : <ChartRangeModel>[];

    final expenseResultState =
        context.watch<ForecastProvider>().expenseResultState;
    final expenseForecastData =
        expenseResultState is ExpenseForecastLoadedState
            ? expenseResultState.listData
            : <ChartModel>[];
    final expenseForecastRangeData =
        expenseResultState is ExpenseForecastLoadedState
            ? expenseResultState.listRangeData
            : <ChartRangeModel>[];

    return Scaffold(
      backgroundColor: BizColors.colorBackground.getColor(context),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<ForecastProvider>(
            context,
            listen: false,
          ).getSaleForecast();

          Provider.of<ForecastProvider>(
            context,
            listen: false,
          ).getExpenseForecast();
        },
        child: ListView(
          padding: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0 + MediaQuery.of(context).padding.top,
            bottom: 24.0,
          ),
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
            ForecastChart(
              tooltipBehavior: _tooltipBehavior,
              saleForecastData: saleForecastData,
              saleForecastRangeData: saleForecastRangeData,
              expenseForecastData: expenseForecastData,
              expenseForecastRangeData: expenseForecastRangeData,
            ),
            const SizedBox(height: 16),
            Consumer<ForecastProvider>(
              builder: (context, value, child) {
                switch (value.saleResultState) {
                  case SaleForecastLoadingState():
                    return _buildLoading();
                  case SaleForecastLoadedState(summary: var summary):
                    return ForecastGradientCard(
                      colors: [
                        BizColors.colorGreen.getColor(context),
                        BizColors.colorGreenDark.getColor(context),
                      ],
                      title: "Future Sales Insights",
                      content: summary,
                    );
                  case SaleForecastErrorState(error: var message):
                    return _buildError(message);
                  default:
                    return const SizedBox();
                }
              },
            ),
            const SizedBox(height: 16),
            Consumer<ForecastProvider>(
              builder: (context, value, child) {
                return switch (value.expenseResultState) {
                  ExpenseForecastLoadingState() => _buildLoading(),
                  ExpenseForecastLoadedState(summary: var summary) =>
                    ForecastGradientCard(
                      colors: [
                        BizColors.colorOrange.getColor(context),
                        BizColors.colorOrangeDark.getColor(context),
                      ],
                      title: "Upcoming Cost Trends",
                      content: summary,
                    ),
                  ExpenseForecastErrorState(error: var message) => _buildError(
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

  Widget _buildError(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: BizColors.colorText.getColor(context)),
      ),
    );
  }
}
