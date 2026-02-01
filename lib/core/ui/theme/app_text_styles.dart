import 'package:flutter/material.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';

abstract class AppTextStyles {
  static const TextStyle titleLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle textHint = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );
  // Bottom Navigation
  static const TextStyle btnNavActive = TextStyle(
    fontSize: 13,
    color: AppColors.btmNavActiveItem,
  );
  static const TextStyle btnNavInactive = TextStyle(
    fontSize: 13,
    color: AppColors.btmNavInActiveItem,
  );
}
