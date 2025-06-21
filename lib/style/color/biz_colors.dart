import 'package:flutter/material.dart';

enum BizColors {
  colorPrimary("ColorPrimary", Colors.blueAccent);

  const BizColors(this.name, this.color);

  final String name;
  final Color color;

  Color getColor(BuildContext context) {
    return color;
  }
}
