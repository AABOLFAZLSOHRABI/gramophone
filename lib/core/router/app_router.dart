import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/features/auth/pages/signup/email_step_page.dart';
import 'package:gramophone/features/auth/pages/signup/email_verification_page.dart';
import 'package:gramophone/features/auth/pages/signup/password_step_page.dart';
import 'package:gramophone/features/auth/pages/signup/preferences/favorite_artists_page.dart';
import 'package:gramophone/features/auth/pages/signup/preferences/favorite_podcasts_page.dart';
import 'package:gramophone/features/auth/pages/signup/profile_info_step_page.dart';
import 'package:gramophone/features/auth/pages/start_page.dart';
import 'package:gramophone/features/main/pages/main_shell_page.dart';
import 'package:gramophone/features/main/pages/tabs/home_tab_page.dart';
import 'package:gramophone/features/main/pages/tabs/library_tab_page.dart';
import 'package:gramophone/features/main/pages/tabs/search_tab_page.dart';

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
        path: RouteNames.emailVerificationPage,
        builder: (context, state) => const EmailVerificationPage(),
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
