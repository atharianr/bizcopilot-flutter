import 'package:flutter/material.dart';

import '../../static/reports/report_type.dart';
import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';

class BizRadioButton extends StatelessWidget {
  final String label;
  final ReportType value;
  final ReportType selectedTag;
  final VoidCallback onTap;

  const BizRadioButton({
    super.key,
    required this.label,
    required this.value,
    required this.selectedTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = BizColors.colorPrimary.getColor(context);
    final grayColor = BizColors.colorGrey.getColor(context);
    final whiteColor = BizColors.colorWhite.getColor(context);
    final isSelected = value == selectedTag;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : grayColor,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: BizTextStyles.bodyLargeMedium.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
