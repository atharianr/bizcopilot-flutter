import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../style/color/biz_colors.dart';

class ShimmerReportsCard extends StatelessWidget {
  const ShimmerReportsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: BizColors.colorGrey.getColor(context).withAlpha(77),
      highlightColor: BizColors.colorGrey.getColor(context).withAlpha(26),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
