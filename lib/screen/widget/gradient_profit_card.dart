import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';

class GradientProfitCard extends StatelessWidget {
  final List<BizColors> colors;

  const GradientProfitCard({super.key, required this.colors});

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
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        style: BizTextStyles.labelSmallMedium.copyWith(
                          color: BizColors.colorWhite.getColor(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2, right: 6),
                    child: Icon(
                      Icons.info_outline,
                      color: BizColors.colorWhite.getColor(context),
                      size: 8,
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
                  "IDR 2.561.000",
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
