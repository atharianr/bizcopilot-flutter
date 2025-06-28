import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
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
    return Text(
      message,
      style: TextStyle(color: BizColors.colorText.getColor(context)),
    );
  }
}
