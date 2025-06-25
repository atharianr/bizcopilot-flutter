import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';

class GradientProfitCard extends StatelessWidget {
  final String forecast;
  final String amount;
  final List<BizColors> colors;
  const GradientProfitCard({
    super.key,
    required this.forecast,
    required this.amount,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.map((color) => color.getColor(context)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 4,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: BizColors.colorBlack
                  .getColor(context)
                  .withAlpha((255 * 0.06).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        forecast,
                        style: BizTextStyles.labelSmallMedium.copyWith(
                          color: BizColors.colorWhite.getColor(context),
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2, right: 6),
                    child: SvgPicture.asset(
                      'assets/images/ic_artificial_intelligence_white_12.svg',
                      width: 8,
                      height: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 12.0,
              right: 12.0,
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/ic_profit_white_20.svg'),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Profit",
                    style: BizTextStyles.titleLargeBold.copyWith(
                      color: BizColors.colorWhite.getColor(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  amount,
                  style: BizTextStyles.titleLargeBold.copyWith(
                    color: BizColors.colorWhite.getColor(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
