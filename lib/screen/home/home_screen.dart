import 'package:bizcopilot_flutter/provider/example/example_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../static/state/example_api_result_state.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';
import '../widget/gradient_card.dart';
import '../widget/gradient_profit_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // ini contoh trigger hit api di page start
    context.read<ExampleApiProvider>().addRestaurantReview(
      "id",
      "name",
      "review",
    );
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: BizColors.colorBackground.getColor(context),
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight + 24.0),
        child: Column(
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
                      forecast:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      colors: [BizColors.colorGreen, BizColors.colorGreenDark],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientCard(
                      title: "Expenses",
                      iconUri: "assets/images/ic_arrow_down_circle_white_12.svg",
                      amount: "IDR 2.439.000",
                      forecast:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      colors: [
                        BizColors.colorOrange,
                        BizColors.colorOrangeDark,
                      ],
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
            const SizedBox(height: 24),
            Center(
              child: Consumer<ExampleApiProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    // nanti di isi UI nya
                    ExampleApiLoadingState() => Text(
                      "Loading",
                      style: TextStyle(
                        color: BizColors.colorText.getColor(context),
                      ),
                    ),
                    ExampleApiLoadedState(data: var data) => Text(
                      data,
                      style: TextStyle(
                        color: BizColors.colorText.getColor(context),
                      ),
                    ),
                    ExampleApiErrorState(error: var message) => Text(
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
      ),
    );
  }
}
