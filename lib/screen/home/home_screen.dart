import 'package:bizcopilot_flutter/provider/daily_reports/daily_reports_provider.dart';
import 'package:bizcopilot_flutter/screen/widget/reports/shimmer_reports_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../static/state/daily_reports_result_state.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';
import '../widget/gradient_card.dart';
import '../widget/gradient_profit_card.dart';
import '../widget/reports/reports_card.dart';

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
      body: ListView(
        padding: EdgeInsets.only(top: statusBarHeight + 24.0),
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
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GradientProfitCard(
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
                    amount: "IDR 5.000.000",
                    forecast: "Lorem ipsum dolor sit amet...",
                    colors: [BizColors.colorGreen, BizColors.colorGreenDark],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientCard(
                    title: "Expenses",
                    iconUri: "assets/images/ic_arrow_down_circle_white_12.svg",
                    amount: "IDR 2.439.000",
                    forecast: "Lorem ipsum dolor sit amet...",
                    colors: [BizColors.colorOrange, BizColors.colorOrangeDark],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Daily Reports",
              style: BizTextStyles.titleLarge.copyWith(
                color: BizColors.colorText.getColor(context),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Consumer<DailyReportsProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  DailyReportsLoadingState() => Column(
                    children: List.generate(3, (index) => ShimmerReportsCard()),
                  ),
                  DailyReportsLoadedState(data: var data) => Column(
                    children: List.generate(data.length, (index) {
                      return ListReports();
                    }),
                  ),
                  DailyReportsErrorState(error: var message) => Text(
                    message,
                    style: TextStyle(
                      color: BizColors.colorText.getColor(context),
                    ),
                  ),
                  _ => const SizedBox(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
