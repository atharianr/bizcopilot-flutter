import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/daily_reports/daily_reports_provider.dart';
import '../../static/state/daily_reports_result_state.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';
import '../../utils/currency_utils.dart';
import '../widget/reports/reports_card.dart';
import '../widget/shimmer_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.colorBackground.getColor(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            Provider.of<DailyReportsProvider>(
              context,
              listen: false,
            ).getDailyReports(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Text(
              "Your Reports",
              style: BizTextStyles.titleLargeBold.copyWith(
                color: BizColors.colorText.getColor(context),
              ),
            ),
            Center(
              child: Consumer<DailyReportsProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    DailyReportsLoadingState() => _buildLoading(),
                    DailyReportsLoadedState(data: var data) => _buildLoaded(
                      data,
                    ),
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

  Widget _buildLoading() {
    return Column(
      children: [
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(right: 144),
          child: ShimmerCard(height: 24),
        ),
        const SizedBox(height: 6),
        ...List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ShimmerCard(),
          );
        }),
      ],
    );
  }

  Widget _buildLoaded(List<dynamic> data) {
    // Group data by formatted date
    final Map<String, List<dynamic>> groupedData = {};

    for (var item in data) {
      String date;
      try {
        date = DateFormat(
          'EEEE, dd MMMM yyyy',
        ).format(DateTime.parse(item.createdAt));
      } catch (e) {
        date = 'Unknown Date';
      }

      if (groupedData[date] == null) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          groupedData.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // const Divider(),
                ...entry.value.map((item) {
                  return ListReports(
                    title: item.name ?? "",
                    description: item.description ?? "",
                    amount: CurrencyUtils.formatCurrency(
                      item.currency,
                      item.value ?? "",
                    ),
                    type: item.transactionType ?? "",
                  );
                }),
                const SizedBox(height: 12),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildError(String message) {
    return Text(message, style: TextStyle(color: BizColors.colorText.color));
  }
}
