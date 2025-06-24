import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../style/color/biz_colors.dart';

class ImageSvgWidget extends StatelessWidget {
  final String iconUri;
  final double width;
  final double height;

  const ImageSvgWidget({
    super.key,
    required this.iconUri,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            BizColors.colorGreen.getColor(context),
            BizColors.colorGreenDark.getColor(context),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: SvgPicture.asset(
        iconUri,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        // Color will be overridden by ShaderMask
        width: width,
        height: height,
      ),
    );
  }
}
