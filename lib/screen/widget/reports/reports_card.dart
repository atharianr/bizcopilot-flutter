import 'package:flutter/material.dart';

import '../../../style/color/biz_colors.dart';
import '../../../style/typography/biz_text_styles.dart';
import '../image_svg_widget.dart';

class ListReports extends StatelessWidget {
  const ListReports({super.key});

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
            ImageSvgWidget(
              iconUri: "assets/images/ic_arrow_up_circle_white_12.svg",
              width: 32,
              height: 32,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title Lorem Ipsum",
                    style: BizTextStyles.bodyLargeExtraBold.copyWith(
                      color: BizColors.colorText.getColor(context),
                    ),
                  ),
                  Text(
                    "Description Lorem ipsum dolor sit amet...",
                    style: BizTextStyles.bodyLargeMedium.copyWith(
                      color: BizColors.colorText.getColor(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Text(
              "+50.000",
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
