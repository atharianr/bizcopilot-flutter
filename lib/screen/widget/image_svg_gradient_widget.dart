import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageSvgGradientWidget extends StatelessWidget {
  final String iconUri;
  final double width;
  final double height;
  final List<Color> colors;

  const ImageSvgGradientWidget({
    super.key,
    required this.iconUri,
    required this.width,
    required this.height,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
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
