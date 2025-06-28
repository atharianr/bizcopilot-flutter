import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';

class ForecastGradientCard extends StatelessWidget {
  final List<Color> colors;
  final String title;
  final String content;

  const ForecastGradientCard({
    super.key,
    required this.colors,
    required this.title,
    required this.content,
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
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/ic_profit_white_20.svg'),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: BizTextStyles.titleLargeBold.copyWith(
                    color: BizColors.colorWhite.getColor(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
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
                        content,
                        style: BizTextStyles.bodyLargeRegularBold.copyWith(
                          color: BizColors.colorWhite.getColor(context),
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
