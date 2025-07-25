import 'package:bizcopilot_flutter/provider/daily_reports/daily_reports_provider.dart';
import 'package:bizcopilot_flutter/provider/daily_reports/home_widgets_provider.dart';
import 'package:bizcopilot_flutter/provider/forecast/forecast_provider.dart';
import 'package:bizcopilot_flutter/static/state/sale_forecast_result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../static/state/daily_reports_result_state.dart';
import '../../static/state/home_widgets_result_state.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';
import '../../utils/currency_utils.dart';
import '../widget/gradient_card.dart';
import '../widget/gradient_profit_card.dart';
import '../widget/reports/reports_card.dart';
import '../widget/shimmer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final home = context.read<HomeWidgetsProvider>();
      final daily = context.read<DailyReportsProvider>();
      final forecast = context.read<ForecastProvider>();

      home.getHomeWidgets();
      daily.getDailyReports();
      forecast.getSaleForecast();
      forecast.getExpenseForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.colorBackground.getColor(context),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<HomeWidgetsProvider>(
            context,
            listen: false,
          ).getHomeWidgets();

          Provider.of<DailyReportsProvider>(
            context,
            listen: false,
          ).getDailyReports();

          Provider.of<ForecastProvider>(
            context,
            listen: false,
          ).getSaleForecast();

          Provider.of<ForecastProvider>(
            context,
            listen: false,
          ).getExpenseForecast();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top,
              ),
              sliver: SliverToBoxAdapter(child: _buildGreetingSection(context)),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Consumer<HomeWidgetsProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    HomeWidgetsLoadingState() => _buildHomeLoading(),
                    HomeWidgetsLoadedState(data: var data) => _buildHomeLoaded(
                      data,
                    ),
                    HomeWidgetsErrorState(error: var message) => _buildError(
                      message,
                    ),
                    _ => const SizedBox(),
                  };
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: _buildDailyReportsHeader(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            Consumer<DailyReportsProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  DailyReportsLoadingState() => _buildDailyLoading(),

                  DailyReportsLoadedState(reports: final data)
                      when data.isEmpty =>
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildNoReportsAvailable(),
                    ),

                  DailyReportsLoadedState(reports: final data) => SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 4,
                        ),
                        child: ReportsCard(reportData: item),
                      );
                    }, childCount: data.length),
                  ),

                  DailyReportsErrorState(error: final message) =>
                    SliverToBoxAdapter(child: _buildError(message)),

                  _ => const SliverToBoxAdapter(child: SizedBox()),
                };
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Hello,",
            style: BizTextStyles.titleLarge.copyWith(
              color: BizColors.colorText.getColor(context),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Bayu Suseno",
            style: BizTextStyles.titleLargeBold.copyWith(
              color: BizColors.colorText.getColor(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeLoading() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ShimmerCard(),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(child: ShimmerCard()),
              const SizedBox(width: 12),
              Expanded(child: ShimmerCard()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeLoaded(List<dynamic> data) {
    final saleResultState = context.watch<ForecastProvider>().saleResultState;
    final saleSummary =
        saleResultState is SaleForecastLoadedState
            ? saleResultState.summary
            : '';

    final expenseResultState =
        context.watch<ForecastProvider>().saleResultState;
    final expenseSummary =
        expenseResultState is SaleForecastLoadedState
            ? expenseResultState.summary
            : '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GradientProfitCard(
            forecast: "test forecast profit",
            amount: CurrencyUtils.formatCurrency("Rp", data[0].value),
            colors: [
              BizColors.colorPrimary.getColor(context),
              BizColors.colorPrimaryDark.getColor(context),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GradientCard(
                  title: "Sales",
                  iconUri: "assets/images/ic_arrow_up_circle_white_12.svg",
                  forecast: saleSummary,
                  amount: CurrencyUtils.formatCurrency("Rp", data[2].value),
                  colors: [
                    BizColors.colorGreen.getColor(context),
                    BizColors.colorGreenDark.getColor(context),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientCard(
                  title: "Expenses",
                  iconUri: "assets/images/ic_arrow_down_circle_white_12.svg",
                  forecast: expenseSummary,
                  amount: CurrencyUtils.formatCurrency("Rp", data[1].value),
                  colors: [
                    BizColors.colorOrange.getColor(context),
                    BizColors.colorOrangeDark.getColor(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyReportsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        "Daily Reports",
        style: BizTextStyles.titleLarge.copyWith(
          color: BizColors.colorText.getColor(context),
        ),
      ),
    );
  }

  Widget _buildDailyLoading() {
    return SliverToBoxAdapter(
      child: Column(
        children: List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
            child: ShimmerCard(),
          );
        }),
      ),
    );
  }

  Widget _buildNoReportsAvailable() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No reports available for today',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: BizColors.colorText.getColor(context)),
        ),
      ),
    );
  }
}
