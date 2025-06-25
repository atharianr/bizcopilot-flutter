import 'package:flutter/material.dart';

import '../../../style/color/biz_colors.dart';
import '../../../style/typography/biz_text_styles.dart';
import '../image_svg_gradient_widget.dart';

class ListReports extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final String type;

  const ListReports({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
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
                  type == "sales"
                      ? "assets/images/ic_arrow_up_circle_white_12.svg"
                      : "assets/images/ic_arrow_down_circle_white_12.svg",
              width: 32,
              height: 32,
              colors:
                  type == "sales"
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
                    title,
                    style: BizTextStyles.bodyLargeExtraBold.copyWith(
                      color: BizColors.colorText.getColor(context),
                    ),
                  ),
                  Text(
                    description,
                    style: BizTextStyles.bodyLargeMedium.copyWith(
                      color: BizColors.colorText.getColor(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Text(
              type == "sales" ? "+$amount" : "-$amount",
              style: BizTextStyles.bodyLargeExtraBold.copyWith(
                color: BizColors.colorGreenDark.getColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
