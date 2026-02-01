import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/features/auth/presentation/pages/signup/email_step_page.dart';
import 'package:gramophone/features/auth/presentation/pages/signup/email_verification_page.dart';
import 'package:gramophone/features/auth/presentation/pages/signup/password_step_page.dart';
import 'package:gramophone/features/auth/presentation/pages/signup/preferences/favorite_artists_page.dart';
import 'package:gramophone/features/auth/presentation/pages/signup/preferences/favorite_podcasts_page.dart';
import 'package:gramophone/features/auth/presentation/pages/signup/profile_info_step_page.dart';
import 'package:gramophone/features/auth/presentation/pages/start_page.dart';

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
    ],
  );
}
