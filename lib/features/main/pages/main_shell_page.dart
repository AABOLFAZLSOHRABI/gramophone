import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/widgets/btn_nav_item.dart';
import 'package:gramophone/core/ui/widgets/mini_player_bar.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';
import 'package:gramophone/features/player/presentation/bloc/player_state.dart';
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<PlayerBloc, PlayerState>(
            bloc: sl<PlayerBloc>(),
            builder: (context, state) {
              final track = state.currentTrack;
              if (track == null) {
                return const SizedBox.shrink();
              }

              return MiniPlayerBar(
                track: track,
                isPlaying: state.isPlaying,
                onTap: () => context.push(RouteNames.playerPage, extra: track),
                onTogglePlayPause: () =>
                    sl<PlayerBloc>().add(const TogglePlayPausePressed()),
                onNext: () => sl<PlayerBloc>().add(const NextPressed()),
              );
            },
          ),
          Container(
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
                  onTap: () =>
                      navigationShell.goBranch(BtnNavScreenIndex.search),
                ),
                BtnNavItem(
                  iconSvgPath: Assets.icons.library,
                  isActive: currentIndex == BtnNavScreenIndex.library,
                  label: AppStrings.library,
                  onTap: () =>
                      navigationShell.goBranch(BtnNavScreenIndex.library),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
