import 'package:flutter/material.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
      ),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.titleBold,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyMedium: AppTextStyles.textHint,
      ),
    );
  }
}
