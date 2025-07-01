import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;

  const BizTextInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
    this.scrollPadding,
    this.keyboardType,
    this.inputFormatters,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = BizColors.colorPrimary.getColor(context);
    final grayColor = BizColors.colorGrey.getColor(context);
    final errorColor = BizColors.colorOrangeDark.getColor(context);

    OutlineInputBorder inputBorder(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: BizTextStyles.bodyLargeMedium,
          readOnly: readOnly,
          maxLines: maxLines,
          scrollPadding: scrollPadding ?? const EdgeInsets.all(20),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: TextStyle(color: grayColor),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: inputBorder(grayColor, 1),
            enabledBorder: inputBorder(grayColor, 1),
            focusedBorder: inputBorder(primaryColor, 1.5),
            errorBorder: inputBorder(errorColor, 1.5),
            focusedErrorBorder: inputBorder(errorColor, 1.5),
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: onChanged,
          onTap: onTap,
        ),
      ],
    );
  }
}
