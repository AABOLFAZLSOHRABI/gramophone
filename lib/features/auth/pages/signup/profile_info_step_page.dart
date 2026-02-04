import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/ui/widgets/auth_step_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/gen/assets.gen.dart';

class ProfileInfoStepPage extends StatefulWidget {
  const ProfileInfoStepPage({super.key});

  @override
  State<ProfileInfoStepPage> createState() => _ProfileInfoStepPageState();
}

class _ProfileInfoStepPageState extends State<ProfileInfoStepPage> {
  bool _sendNewsAndOffers = false;
  bool _shareRegistrationData = false;

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
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaddedText(
                text: AppStrings.whatsYourName,
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.start,
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
                text: AppStrings.thisAppearsOnYourGramophoneProfile,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.start,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Divider(color: AppColors.btmNavInActiveItem),
              ),
              PaddedText(
                text: AppStrings.termsOfUseAgreement,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.start,
                padding: EdgeInsets.symmetric(horizontal: 30.w),
              ),
              PaddedText(
                text: AppStrings.termsOfUse,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.start,
                color: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 30.w),
              ),
              PaddedText(
                text: AppStrings.privacyPolicyDescription,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.start,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 30.w),
              ),
              PaddedText(
                text: AppStrings.privacyPolicy,
                style: AppTextStyles.titleSmall,
                textAlign: TextAlign.start,
                color: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 30.w),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.sendNewsAndOffers,
                            style: AppTextStyles.titleSmall,
                            textAlign: TextAlign.start,
                          ),
                          10.h.height,
                          Text(
                            AppStrings.shareRegistrationData,
                            style: AppTextStyles.titleSmall,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Checkbox(
                          value: _sendNewsAndOffers,
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _sendNewsAndOffers = value;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          side: const BorderSide(
                            color: AppColors.textSecondary,
                          ),
                          activeColor: AppColors.primary,
                          checkColor: AppColors.textDark,
                        ),
                        Checkbox(
                          value: _shareRegistrationData,
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _shareRegistrationData = value;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          side: const BorderSide(
                            color: AppColors.textSecondary,
                          ),
                          activeColor: AppColors.primary,
                          checkColor: AppColors.textDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              330.h.height,
              CenteredButton(
                text: AppStrings.createAnAccount,
                width: 180.w,
                backgroundColor: AppColors.btmNavActiveItem,
                onPressed: () => context.push(RouteNames.favoriteArtistsPage),
              ), // TODO = By pressing the button, a pop-up will open and ask the user if the pass is correct. If they say yes, they will go to the next page.
            ],
          ),
        ),
      ),
    );
  }
}
