import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';
import 'package:gramophone/core/ui/widgets/app_button.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/gen/assets.gen.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Top positioned background image
            Positioned(
              height: 593.h,
              top: 0,
              right: 0,
              left: 0,
              child: Image.asset(
                Assets.images.gramophoneBackground.path,
                fit: BoxFit.cover,
              ),
            ),
            // Bottom positioned column with logo, texts, and buttons
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.w),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.logo,
                      height: 53.h,
                      width: 53.w,
                    ),
                    18.h.height,
                    // Texts for Millions of songs and Free on Gramophone
                    Text(
                      AppStrings.millionsOfSongs,
                      style: AppTextStyles.titleLarge,
                    ),
                    Text.rich(
                      TextSpan(
                        text: AppStrings.freeOn,
                        children: [
                          TextSpan(
                            text: AppStrings.gramophone,
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                      style: AppTextStyles.titleLarge,
                    ),
                    30.h.height,
                    // Sign Up and Continue with Google Buttons
                    AppButton(
                      onPressed: () =>
                          context.push(RouteNames.emailStepPage),
                      text: AppStrings.signUpFree,
                      backgroundColor: AppColors.primary,
                      borderRadius: AppDimens.radiusButton,
                      textColor: AppColors.textDark,
                    ),
                    12.h.height,
                    // Continue with Google Button
                    AppButton(
                      onPressed: () {},
                      text: AppStrings.continueWithGoogle,
                      backgroundColor: AppColors.background,
                      borderRadius: AppDimens.radiusButton,
                      textColor: AppColors.textWhite,
                      borderColor: AppColors.borderColorWhite,
                      iconPath: Assets.icons.google,
                    ),
                    12.h.height,
                    // Continue with Facebook Button
                    AppButton(
                      onPressed: () {},
                      text: AppStrings.continueWithFacebook,
                      backgroundColor: AppColors.background,
                      borderRadius: AppDimens.radiusButton,
                      textColor: AppColors.textWhite,
                      borderColor: AppColors.borderColorWhite,
                      iconPath: Assets.icons.facebook,
                    ),
                    12.h.height,
                    // Continue with Apple Button
                    AppButton(
                      onPressed: () {},
                      text: AppStrings.continueWithApple,
                      backgroundColor: AppColors.background,
                      borderRadius: AppDimens.radiusButton,
                      textColor: AppColors.textWhite,
                      borderColor: AppColors.borderColorWhite,
                      iconPath: Assets.icons.apple,
                    ),
                    12.h.height,
                    // Sign In Text Button
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppStrings.signIn,
                        style: AppTextStyles.titleMedium,
                      ),
                    ),
                    54.h.height,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
