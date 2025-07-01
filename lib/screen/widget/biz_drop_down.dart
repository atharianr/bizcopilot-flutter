import 'package:flutter/material.dart';

import '../../style/color/biz_colors.dart';
import '../../style/typography/biz_text_styles.dart';

class BizDropDown extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  const BizDropDown({
    super.key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
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

    return DropdownButtonFormField<String>(
      value: value?.isNotEmpty == true ? value : null,
      hint: Text(hintText, style: TextStyle(color: grayColor)),
      items:
          items.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(
                category,
                style: BizTextStyles.bodyLargeMedium.copyWith(
                  color: BizColors.colorText.getColor(context),
                ),
              ),
            );
          }).toList(),
      onChanged: onChanged,
      style: BizTextStyles.bodyLargeMedium.copyWith(
        color: BizColors.colorText.getColor(context),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: inputBorder(grayColor, 1),
        enabledBorder: inputBorder(grayColor, 1),
        focusedBorder: inputBorder(primaryColor, 1.5),
        errorBorder: inputBorder(errorColor, 1.5),
        focusedErrorBorder: inputBorder(errorColor, 1.5),
        errorText: errorText,
      ),
    );
  }
}
