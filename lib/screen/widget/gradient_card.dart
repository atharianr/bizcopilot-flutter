import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';

class GradientCard extends StatelessWidget {
  final String title;
  final String iconUri;
  final String amount;
  final String forecast;
  final List<Color> colors;

  const GradientCard({
    super.key,
    required this.title,
    required this.iconUri,
    required this.amount,
    required this.forecast,
    required this.colors,
  }) : assert(
         colors.length >= 2,
         'At least two colors are required for the gradient.',
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        forecast,
                        style: BizTextStyles.labelSmallMedium.copyWith(
                          color: BizColors.colorWhite.getColor(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
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
              bottom: 2.0,
              left: 12.0,
              right: 12.0,
            ),
            child: Row(
              children: [
                SvgPicture.asset(iconUri),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: BizTextStyles.bodyLargeExtraBold.copyWith(
                      color: BizColors.colorWhite.getColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 12.0,
              right: 12.0,
            ),
            child: Text(
              amount,
              style: BizTextStyles.titleLargeBold.copyWith(
                color: BizColors.colorWhite.getColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
