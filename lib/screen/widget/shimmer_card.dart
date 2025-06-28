import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../style/color/biz_colors.dart';

class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerCard({super.key, this.width = 96, this.height = 96});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: BizColors.colorGrey.getColor(context).withAlpha(77),
      highlightColor: BizColors.colorGrey.getColor(context).withAlpha(26),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
