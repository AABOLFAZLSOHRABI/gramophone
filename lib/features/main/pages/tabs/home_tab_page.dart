import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/gen/assets.gen.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              25.h.height,
              // header recently played
              Padding(
                padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      AppStrings.recentlyPlayed,
                      style: AppTextStyles.titleBoldSmall,
                    ),
                    130.w.width,
                    SvgPicture.asset(Assets.icons.alert),
                    Padding(
                      padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 0),
                      child: SvgPicture.asset(Assets.icons.orientationLock),
                    ),
                    SvgPicture.asset(Assets.icons.settings),
                  ],
                ),
              ),
              10.h.height,
              // list recently played
              SizedBox(
                height: 142.h,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.images.logoApp.path,
                            height: 105.h,
                            width: 105.w,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              AppStrings.appName,
                              style: AppTextStyles.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // review header
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 15.h, bottom: 15.h),
                child: SizedBox(
                  height: 60.h,
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.images.logoApp.path,
                        height: 58.h,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.gramophoneWrapped,
                              style: AppTextStyles.textHint,
                            ),
                            Text(
                              AppStrings.your2026InReview,
                              style: AppTextStyles.titleBold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // list review
              SizedBox(
                height: 195.h,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.images.logoApp.path,
                            height: 155.h,
                            width: 155.w,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              AppStrings.appName,
                              style: AppTextStyles.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // text editors Picks
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                child: Text(
                  AppStrings.editorsPicks,
                  style: AppTextStyles.titleLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              // list editors Picks
              SizedBox(
                height: 195.h,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.images.logoApp.path,
                            height: 155.h,
                            width: 155.w,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              AppStrings.appName,
                              style: AppTextStyles.titleSmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
