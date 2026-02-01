import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';

class BtnNavItem extends StatelessWidget {
  final String? iconSvgPath;
  final Widget? customIcon;
  final String label;
  final bool isActive;
  final void Function() onTap;

  const BtnNavItem({
    super.key,
    this.iconSvgPath,
    this.customIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : assert(
         iconSvgPath != null || customIcon != null,
         'Either iconSvgPath or customIcon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customIcon ??
                  SvgPicture.asset(
                    iconSvgPath!,
                    fit: BoxFit.none,
                    colorFilter: ColorFilter.mode(
                      isActive
                          ? AppColors.btmNavActiveItem
                          : AppColors.btmNavInActiveItem,
                      BlendMode.srcIn,
                    ),
                  ),
              2.h.height,
              Text(
                label,
                style: isActive
                    ? AppTextStyles.btnNavActive
                    : AppTextStyles.btnNavInactive,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
