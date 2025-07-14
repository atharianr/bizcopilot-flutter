import 'package:bizcopilot_flutter/data/model/response/daily_reports_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/daily_reports/daily_reports_provider.dart';
import '../../static/state/monthly_reports_result_state.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';
import '../widget/reports/reports_card.dart';
import '../widget/shimmer_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DailyReportsProvider>(
        context,
        listen: false,
      ).getMonthlyReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BizColors.colorBackground.getColor(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<DailyReportsProvider>(
            context,
            listen: false,
          ).getMonthlyReports();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Reports",
                      style: BizTextStyles.titleLargeBold.copyWith(
                        color: BizColors.colorText.getColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "A look at your reports this month",
                      style: BizTextStyles.bodyLargeMedium.copyWith(
                        color: BizColors.colorText.getColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: Consumer<DailyReportsProvider>(
                builder: (context, value, child) {
                  return switch (value.monthlyReportsResultState) {
                    MonthlyReportsLoadingState() => SliverToBoxAdapter(
                      child: _buildLoading(),
                    ),
                    MonthlyReportsLoadedState(reports: final data)
                        when data.isEmpty =>
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(),
                      ),
                    MonthlyReportsLoadedState(reports: final data) =>
                      _buildGroupedReports(data),
                    MonthlyReportsErrorState(error: final message) =>
                      SliverToBoxAdapter(child: _buildError(message)),
                    _ => const SliverToBoxAdapter(child: SizedBox()),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
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

  Widget _buildEmptyState() {
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
            'No reports available',
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

  SliverList _buildGroupedReports(List<Reports> data) {
    final Map<String, List<Reports>> groupedData = {};

    for (var item in data) {
      String date;
      try {
        date = DateFormat(
          'EEEE, dd MMMM yyyy',
        ).format(DateTime.parse(item.createdAt ?? ""));
      } catch (e) {
        date = 'Unknown Date';
      }

      groupedData.putIfAbsent(date, () => []).add(item);
    }

    final List<Widget> widgets = [];

    groupedData.forEach((date, items) {
      widgets.addAll([
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            date,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...items.map((item) => ReportsCard(reportData: item)),
        const SizedBox(height: 12),
      ]);
    });

    return SliverList(delegate: SliverChildListDelegate(widgets));
  }

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Text(message, style: TextStyle(color: BizColors.colorText.color)),
    );
  }
}
