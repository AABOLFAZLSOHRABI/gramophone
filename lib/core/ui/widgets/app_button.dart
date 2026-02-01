import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.borderColor,
    this.iconPath,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Color? borderColor;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimens.radiusButton,
          ),
        ),
        minimumSize: Size(337.w, 49.h),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (iconPath != null)
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(iconPath!, height: 20.h, width: 20.w),
            ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 13.h),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                color: textColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
