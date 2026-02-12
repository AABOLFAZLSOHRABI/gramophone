import 'package:go_router/go_router.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/features/auth/pages/signup/email_step_page.dart';
import 'package:gramophone/features/auth/pages/signup/password_step_page.dart';
import 'package:gramophone/features/auth/pages/signup/preferences/favorite_artists_page.dart';
import 'package:gramophone/features/auth/pages/signup/preferences/favorite_podcasts_page.dart';
import 'package:gramophone/features/auth/pages/signup/profile_info_step_page.dart';
import 'package:gramophone/features/auth/pages/start_page.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/pages/main_shell_page.dart';
import 'package:gramophone/features/main/pages/search_input_page.dart';
import 'package:gramophone/features/main/pages/tabs/home_tab_page.dart';
import 'package:gramophone/features/main/pages/tabs/library_tab_page.dart';
import 'package:gramophone/features/main/pages/tabs/search_tab_page.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';
import 'package:gramophone/features/player/presentation/pages/now_playing_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.start,
    routes: [
      GoRoute(
        path: RouteNames.start,
        builder: (context, state) => const StartPage(),
      ),
      // sign up
      GoRoute(
        path: RouteNames.emailStepPage,
        builder: (context, state) => const EmailStepPage(),
      ),
      GoRoute(
        path: RouteNames.passwordStepPage,
        builder: (context, state) => const PasswordStepPage(),
      ),
      GoRoute(
        path: RouteNames.profileInfoStepPage,
        builder: (context, state) => const ProfileInfoStepPage(),
      ),
      // preferences
      GoRoute(
        path: RouteNames.favoriteArtistsPage,
        builder: (context, state) => const FavoriteArtistsPage(),
      ),
      GoRoute(
        path: RouteNames.favoritePodcastsPage,
        builder: (context, state) => const FavoritePodcastsPage(),
      ),
      GoRoute(
        path: RouteNames.playerPage,
        builder: (context, state) {
          final extra = state.extra;
          final track = extra is Track ? extra : null;
          final currentTrack = sl<PlayerBloc>().state.currentTrack;
          if (track != null && currentTrack?.id != track.id) {
            sl<PlayerBloc>().add(
              LoadQueueAndTrack(queue: [track], startIndex: 0),
            );
          }
          return NowPlayingScreen(track: track);
        },
      ),

      /// main
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.homeTabPage,
                builder: (context, state) => const HomeTabPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.searchTabPage,
                builder: (context, state) => const SearchTabPage(),
                routes: [
                  GoRoute(
                    path: RouteNames.searchInputPage,
                    builder: (context, state) => const SearchInputPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.libraryTabPage,
                builder: (context, state) => const LibraryTabPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
