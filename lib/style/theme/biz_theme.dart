import 'package:bizcopilot_flutter/style/color/biz_colors.dart';
import 'package:flutter/material.dart';

import '../typography/biz_text_styles.dart';

class BizTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: BizColors.colorBackground.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  // static ThemeData get darkTheme {
  //   return ThemeData(
  //     colorSchemeSeed: Colors.orange,
  //     brightness: Brightness.dark,
  //     textTheme: _textTheme,
  //     useMaterial3: true,
  //     appBarTheme: _appBarTheme,
  //   );
  // }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: BizTextStyles.displayLarge,
      displayMedium: BizTextStyles.displayMedium,
      displaySmall: BizTextStyles.displaySmall,
      headlineLarge: BizTextStyles.headlineLarge,
      headlineMedium: BizTextStyles.headlineMedium,
      headlineSmall: BizTextStyles.headlineSmall,
      titleLarge: BizTextStyles.titleLarge,
      titleMedium: BizTextStyles.titleMedium,
      titleSmall: BizTextStyles.titleSmall,
      bodyLarge: BizTextStyles.bodyLargeBold,
      bodyMedium: BizTextStyles.bodyLargeMedium,
      bodySmall: BizTextStyles.bodyLargeRegular,
      labelLarge: BizTextStyles.labelLarge,
      labelMedium: BizTextStyles.labelMedium,
      labelSmall: BizTextStyles.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
    );
  }
}
