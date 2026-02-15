import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:gramophone/features/library/domain/entities/library_album.dart';
import 'package:gramophone/features/library/domain/entities/library_playlist.dart';
import 'package:gramophone/features/library/domain/entities/library_track.dart';
import 'package:gramophone/features/library/presentation/pages/library_album_detail_page.dart';
import 'package:gramophone/features/library/presentation/pages/library_album_list_page.dart';
import 'package:gramophone/features/library/presentation/pages/library_playlist_detail_page.dart';
import 'package:gramophone/features/library/presentation/pages/library_playlists_page.dart';
import 'package:gramophone/features/library/presentation/pages/library_tracks_page.dart';
import 'package:gramophone/features/library/presentation/cubit/library_cubit.dart';
import 'package:gramophone/features/main/pages/main_shell_page.dart';
import 'package:gramophone/features/main/pages/search_input_page.dart';
import 'package:gramophone/features/main/pages/tabs/home_tab_page.dart';
import 'package:gramophone/features/main/pages/tabs/library_tab_page.dart';
import 'package:gramophone/features/main/pages/tabs/search_tab_page.dart';
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
          return NowPlayingScreen(track: track);
        },
      ),
      GoRoute(
        path: RouteNames.libraryAlbumListPage,
        builder: (context, state) {
          final extra = state.extra;
          final title = extra is Map
              ? (extra['title'] as String? ?? 'Albums')
              : 'Albums';
          final albums = extra is Map && extra['albums'] is List<LibraryAlbum>
              ? extra['albums'] as List<LibraryAlbum>
              : const <LibraryAlbum>[];
          return BlocProvider.value(
            value: sl<LibraryCubit>(),
            child: LibraryAlbumListPage(title: title, albums: albums),
          );
        },
      ),
      GoRoute(
        path: RouteNames.libraryAlbumDetailPage,
        builder: (context, state) {
          final extra = state.extra;
          final album = extra is LibraryAlbum
              ? extra
              : const LibraryAlbum(
                  id: 'empty',
                  title: 'Album',
                  artist: 'Unknown artist',
                  tracks: [],
                );
          return BlocProvider.value(
            value: sl<LibraryCubit>(),
            child: LibraryAlbumDetailPage(album: album),
          );
        },
      ),
      GoRoute(
        path: RouteNames.libraryTracksPage,
        builder: (context, state) {
          final extra = state.extra;
          final title = extra is Map
              ? (extra['title'] as String? ?? 'Tracks')
              : 'Tracks';
          final tracks = extra is Map && extra['tracks'] is List<LibraryTrack>
              ? extra['tracks'] as List<LibraryTrack>
              : const <LibraryTrack>[];
          return BlocProvider.value(
            value: sl<LibraryCubit>(),
            child: LibraryTracksPage(title: title, tracks: tracks),
          );
        },
      ),
      GoRoute(
        path: RouteNames.libraryPlaylistsPage,
        builder: (context, state) {
          final extra = state.extra;
          final playlists = extra is List<LibraryPlaylist>
              ? extra
              : const <LibraryPlaylist>[];
          return BlocProvider.value(
            value: sl<LibraryCubit>(),
            child: LibraryPlaylistsPage(playlists: playlists),
          );
        },
      ),
      GoRoute(
        path: RouteNames.libraryPlaylistDetailPage,
        builder: (context, state) {
          final extra = state.extra;
          final playlist = extra is LibraryPlaylist
              ? extra
              : LibraryPlaylist(
                  id: 'empty',
                  name: 'Playlist',
                  trackIds: const [],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
          return BlocProvider.value(
            value: sl<LibraryCubit>(),
            child: LibraryPlaylistDetailPage(playlist: playlist),
          );
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
