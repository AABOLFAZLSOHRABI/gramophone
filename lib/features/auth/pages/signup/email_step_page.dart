import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/ui/widgets/app_button.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/gen/assets.gen.dart';

class EmailStepPage extends StatelessWidget {
  const EmailStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                Text(AppStrings.createAccount),
                SvgPicture.asset(Assets.icons.chevronLeft),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
              child: Text(
                AppStrings.whatsYourEmail,
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.end,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.btmNavInActiveItem,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
              child: Text(
                AppStrings.youWillNeedToConfirmEmailLater,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.end,
              ),
            ),
            45.h.height,
            AppButton(
              text: AppStrings.next,
              onPressed: () => context.push(RouteNames.emailVerificationPage),
            ), // TODO = By pressing the button, a pop-up will open and ask the user if the email is correct. If they say yes, they will go to the next page.
          ],
        ),
      ),
    );
  }
}
