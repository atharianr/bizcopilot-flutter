import 'package:flutter/material.dart';

enum BizColors {
  colorPrimary("ColorPrimary", Color(0xFF569EFF)),
  colorPrimaryDark("ColorPrimaryDark", Color(0xFF2671FF)),
  colorBackground("ColorBackground", Color(0xF9F9FFFF)),
  colorText("ColorText", Color(0xFF1E1E2F)),
  colorWhite("ColorWhite", Color(0xFFFFFFFF)),
  colorBlack("ColorWhite", Color(0xFF000000)),
  colorGrey("ColorGrey", Color(0xFFC6CBD0)),
  colorGreen("ColorGreen", Color(0xFF41EE98)),
  colorGreenDark("ColorGreenDark", Color(0xFF10CA66)),
  colorOrange("ColorOrange", Color(0xFFFFD164)),
  colorOrangeDark("ColorOrangeDark", Color(0xFFFFA12D));

  const BizColors(this.name, this.color);

  final String name;
  final Color color;

  Color getColor(BuildContext context) {
    return color;
  }
}
