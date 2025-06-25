import 'package:bizcopilot_flutter/provider/daily_reports/daily_reports_provider.dart';
import 'package:bizcopilot_flutter/provider/daily_reports/home_widgets_provider.dart';
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
import '../widget/reports/shimmer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeWidgetsProvider>(context, listen: false).getHomeWidgets();
      Provider.of<DailyReportsProvider>(
        context,
        listen: false,
      ).getDailyReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: BizColors.colorBackground.getColor(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            Provider.of<HomeWidgetsProvider>(
              context,
              listen: false,
            ).getHomeWidgets(),
            Provider.of<DailyReportsProvider>(
              context,
              listen: false,
            ).getDailyReports(),
          ]);
        },
        child: ListView(
          padding: EdgeInsets.only(top: statusBarHeight + 24.0),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildGreetingSection(context),
            const SizedBox(height: 24),
            Consumer<HomeWidgetsProvider>(
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
            const SizedBox(height: 24),
            _buildDailyReportsHeader(context),
            const SizedBox(height: 10),
            Center(
              child: Consumer<DailyReportsProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    DailyReportsLoadingState() => _buildDailyLoading(),
                    DailyReportsLoadedState(data: var data) =>
                      _buildDailyLoaded(data),
                    DailyReportsErrorState(error: var message) => _buildError(
                      message,
                    ),
                    _ => const SizedBox(),
                  };
                },
              ),
            ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GradientProfitCard(
            forecast: data[0].forecast ?? "",
            amount: CurrencyUtils.formatCurrency(
              data[0].currency,
              data[0].value,
            ),
            colors: [BizColors.colorPrimary, BizColors.colorPrimaryDark],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(
                child: GradientCard(
                  title: "Sales",
                  iconUri: "assets/images/ic_arrow_up_circle_white_12.svg",
                  forecast: data[1].forecast ?? "",
                  amount: CurrencyUtils.formatCurrency(
                    data[1].currency,
                    data[1].value,
                  ),
                  colors: [BizColors.colorGreen, BizColors.colorGreenDark],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientCard(
                  title: "Expenses",
                  iconUri: "assets/images/ic_arrow_down_circle_white_12.svg",
                  forecast: data[2].forecast ?? "",
                  amount: CurrencyUtils.formatCurrency(
                    data[2].currency,
                    data[2].value,
                  ),
                  colors: [BizColors.colorOrange, BizColors.colorOrangeDark],
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
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
          child: ShimmerCard(),
        );
      }),
    );
  }

  Widget _buildDailyLoaded(List<dynamic> data) {
    return Column(
      children: List.generate(data.length, (index) {
        final item = data[index];
        return ListReports(
          title: item.name ?? "",
          description: item.description ?? "",
          amount: CurrencyUtils.formatCurrency(item.currency, item.value ?? ""),
          type: item.transactionType ?? "",
        );
      }),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        message,
        style: TextStyle(color: BizColors.colorText.getColor(context)),
      ),
    );
  }
}
