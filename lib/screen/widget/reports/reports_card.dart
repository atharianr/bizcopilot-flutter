import 'package:bizcopilot_flutter/data/model/response/product_response.dart';
import 'package:bizcopilot_flutter/static/reports/report_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/model/add_report_model.dart';
import '../../../data/model/response/daily_reports_response.dart';
import '../../../provider/daily_reports/add_report_provider.dart';
import '../../../style/color/biz_colors.dart';
import '../../../style/typography/biz_text_styles.dart';
import '../image_svg_gradient_widget.dart';
import 'add_report_bottom_sheet.dart';

class ReportsCard extends StatelessWidget {
  final Reports reportData;

  const ReportsCard({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddReportProvider>();
    final reportType = ReportType.values.firstWhere(
      (e) => e.name == reportData.transactionType,
      orElse: () => ReportType.expenses,
    );

    return GestureDetector(
      onTap: () {
        provider.setReportModel = AddReportModel(
          name: reportData.name,
          description: reportData.description,
          price: int.tryParse(reportData.value ?? ""),
          product: Products(id: reportData.productId),
          date: DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(reportData.createdAt ?? "")),
          type: reportType,
        );

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder:
              (context) =>
                  AddReportBottomSheet(reportId: reportData.id, isUpdate: true),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BizColors.colorBackground.getColor(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              ImageSvgGradientWidget(
                iconUri:
                    reportType == ReportType.sales
                        ? "assets/images/ic_arrow_up_circle_white_12.svg"
                        : "assets/images/ic_arrow_down_circle_white_12.svg",
                width: 32,
                height: 32,
                colors:
                    reportType == ReportType.sales
                        ? [
                          BizColors.colorGreen.getColor(context),
                          BizColors.colorGreenDark.getColor(context),
                        ]
                        : [
                          BizColors.colorOrange.getColor(context),
                          BizColors.colorOrangeDark.getColor(context),
                        ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportData.name ?? "",
                      style: BizTextStyles.bodyLargeExtraBold.copyWith(
                        color: BizColors.colorText.getColor(context),
                      ),
                    ),
                    Text(
                      reportData.description ?? "",
                      style: BizTextStyles.bodyLargeMedium.copyWith(
                        color: BizColors.colorText.getColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Text(
                reportType == ReportType.sales
                    ? "+Rp${NumberFormat.decimalPattern('id').format(int.tryParse(reportData.value ?? ""))}"
                    : "-Rp${NumberFormat.decimalPattern('id').format(int.tryParse(reportData.value ?? ""))}",
                style: BizTextStyles.bodyLargeExtraBold.copyWith(
                  color: BizColors.colorGreenDark.getColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
