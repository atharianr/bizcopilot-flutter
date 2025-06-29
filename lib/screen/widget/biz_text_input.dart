import 'package:flutter/material.dart';

import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';

class BizTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLines;
  final EdgeInsets? scrollPadding;

  const BizTextInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.scrollPadding,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = BizColors.colorPrimary.getColor(context);
    final grayColor = BizColors.colorGrey.getColor(context);

    OutlineInputBorder inputBorder(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return TextField(
      controller: controller,
      style: BizTextStyles.bodyLargeMedium,
      readOnly: readOnly,
      maxLines: maxLines,
      scrollPadding: scrollPadding ?? const EdgeInsets.all(20),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(color: grayColor),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: inputBorder(grayColor, 1),
        enabledBorder: inputBorder(grayColor, 1),
        focusedBorder: inputBorder(primaryColor, 1.5),
      ),
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}
