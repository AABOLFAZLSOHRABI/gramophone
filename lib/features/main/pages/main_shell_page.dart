import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/widgets/btn_nav_item.dart';
import 'package:gramophone/gen/assets.gen.dart';

abstract class BtnNavScreenIndex {
  static const int home = 0;
  static const int search = 1;
  static const int library = 2;
}

class MainShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: Container(
        color: AppColors.background,
        height: AppDimens.navigationAppBarHight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BtnNavItem(
              iconSvgPath: Assets.icons.homeFilled,
              isActive: currentIndex == BtnNavScreenIndex.home,
              label: AppStrings.home,
              onTap: () => navigationShell.goBranch(BtnNavScreenIndex.home),
            ),
            BtnNavItem(
              iconSvgPath: Assets.icons.search,
              isActive: currentIndex == BtnNavScreenIndex.search,
              label: AppStrings.search,
              onTap: () => navigationShell.goBranch(BtnNavScreenIndex.search),
            ),
            BtnNavItem(
              iconSvgPath: Assets.icons.library,
              isActive: currentIndex == BtnNavScreenIndex.library,
              label: AppStrings.library,
              onTap: () => navigationShell.goBranch(BtnNavScreenIndex.library),
            ),
          ],
        ),
      ),
    );
  }
}
