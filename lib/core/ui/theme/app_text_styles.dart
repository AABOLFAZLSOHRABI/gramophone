import 'package:flutter/material.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';

abstract class AppTextStyles {
  static TextStyle titleBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static TextStyle titleSmall = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle textHint = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
}
