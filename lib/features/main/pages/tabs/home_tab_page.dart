import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/gen/assets.gen.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Text(AppStrings.recentlyPlayed),
                SvgPicture.asset(Assets.icons.alert),
                SvgPicture.asset(Assets.icons.orientationLock),
                SvgPicture.asset(Assets.icons.settings),
              ],
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        // Placeholder for album art
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            Assets.images.logoApp.path,
                            width: 105.w,
                            height: 105.h,
                          ), // Placeholder for the image
                        ),
                        2.h.height,
                        const Text(AppStrings.nameMusic),
                        2.h.height,
                        Row(
                          children: [
                            Image.asset(
                              Assets.images.logoApp.path,
                              width: 58.w,
                              height: 58.h,
                            ),
                            Column(
                              children: [
                                Text(AppStrings.gramophoneWrapped),
                                Text(AppStrings.your2026InReview),
                              ],
                            ),
                          ],
                        ),
                        8.h.height,
                        Row(
                          children: [
                            Image.asset(
                              Assets.images.logoApp.path,
                              width: 153.w,
                              height: 153.h,
                            ),
                            2.h.height,
                            const Text(AppStrings.nameMusic),
                          ],
                        ),
                        8.h.height,
                        const Text(AppStrings.editorsPicks),
                        2.h.height,
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            Assets.images.logoApp.path,
                            width: 154.w,
                            height: 154.h,
                          ), // Placeholder for the image
                        ),
                        2.h.height,
                        const Text(AppStrings.nameMusic),
                        20.h.height,
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: api cancel hast , edit ui