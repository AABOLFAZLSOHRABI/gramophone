import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/core/ui/widgets/auth_step_widgets.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/gen/assets.gen.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';

class EmailStepPage extends StatelessWidget {
  const EmailStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AppBarTextIconAction(
            text: AppStrings.createAccount,
            iconPath: Assets.icons.chevronLeft,
            onIconPressed: () => context.pop(),
            textStyle: AppTextStyles.titleMedium,
            spacing: 110.w,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaddedText(
              text: AppStrings.whatsYourEmail,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.end,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: FilledRoundedTextField(
                fillColor: AppColors.btmNavInActiveItem,
                borderRadius: 5.r,
              ),
            ),
            PaddedText(
              text: AppStrings.youWillNeedToConfirmEmailLater,
              style: AppTextStyles.titleSmall,
              textAlign: TextAlign.end,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
            ),
            45.h.height,
            CenteredButton(
              text: AppStrings.next,
              width: 82.w,
              onPressed: () => context.push(RouteNames.passwordStepPage),
            ),
            // TODO = By pressing the button, a pop-up will open and ask the user
            // if the email is correct. If they say yes, they will go to the next
            // page.
          ],
        ),
      ),
    );
  }
}
