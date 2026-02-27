import 'package:gramophone/domain/entities/search_playlist.dart';
import 'package:gramophone/domain/entities/search_user.dart';
import 'package:gramophone/domain/entities/track.dart';

enum SearchPresetMode {
  text,
  genreTrending,
  tracksTrending,
  tracksUnderground,
  feelingLucky,
  playlistSearch,
}

class SearchState {
  const SearchState({
    required this.query,
    required this.initialMode,
    required this.currentMode,
    required this.activeGenre,
    required this.activeQueryPreset,
    required this.activeTitle,
    required this.isLoadingInitial,
    required this.isLoadingMore,
    required this.errorMessage,
    required this.tracksErrorMessage,
    required this.usersErrorMessage,
    required this.playlistsErrorMessage,
    required this.paginationErrorMessage,
    required this.tracks,
    required this.users,
    required this.playlists,
    required this.hasMoreTracks,
    required this.hasMoreUsers,
    required this.hasMorePlaylists,
    required this.offsetTracks,
    required this.offsetUsers,
    required this.offsetPlaylists,
  });

  const SearchState.initial()
    : query = '',
      initialMode = SearchPresetMode.text,
      currentMode = SearchPresetMode.text,
      activeGenre = null,
      activeQueryPreset = null,
      activeTitle = null,
      isLoadingInitial = false,
      isLoadingMore = false,
      errorMessage = null,
      tracksErrorMessage = null,
      usersErrorMessage = null,
      playlistsErrorMessage = null,
      paginationErrorMessage = null,
      tracks = const [],
      users = const [],
      playlists = const [],
      hasMoreTracks = false,
      hasMoreUsers = false,
      hasMorePlaylists = false,
      offsetTracks = 0,
      offsetUsers = 0,
      offsetPlaylists = 0;

  final String query;
  final SearchPresetMode initialMode;
  final SearchPresetMode currentMode;
  final String? activeGenre;
  final String? activeQueryPreset;
  final String? activeTitle;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? tracksErrorMessage;
  final String? usersErrorMessage;
  final String? playlistsErrorMessage;
  final String? paginationErrorMessage;
  final List<Track> tracks;
  final List<SearchUser> users;
  final List<SearchPlaylist> playlists;
  final bool hasMoreTracks;
  final bool hasMoreUsers;
  final bool hasMorePlaylists;
  final int offsetTracks;
  final int offsetUsers;
  final int offsetPlaylists;

  bool get hasAnyResult =>
      tracks.isNotEmpty || users.isNotEmpty || playlists.isNotEmpty;

  bool get isGenreMode => currentMode == SearchPresetMode.genreTrending;

  bool get isTrackOnlyMode =>
      currentMode == SearchPresetMode.genreTrending ||
      currentMode == SearchPresetMode.tracksTrending ||
      currentMode == SearchPresetMode.tracksUnderground ||
      currentMode == SearchPresetMode.feelingLucky;

  SearchState copyWith({
    String? query,
    SearchPresetMode? initialMode,
    SearchPresetMode? currentMode,
    String? activeGenre,
    String? activeQueryPreset,
    String? activeTitle,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    String? errorMessage,
    String? tracksErrorMessage,
    String? usersErrorMessage,
    String? playlistsErrorMessage,
    String? paginationErrorMessage,
    List<Track>? tracks,
    List<SearchUser>? users,
    List<SearchPlaylist>? playlists,
    bool? hasMoreTracks,
    bool? hasMoreUsers,
    bool? hasMorePlaylists,
    int? offsetTracks,
    int? offsetUsers,
    int? offsetPlaylists,
    bool clearError = false,
    bool clearTracksError = false,
    bool clearUsersError = false,
    bool clearPlaylistsError = false,
    bool clearPaginationError = false,
    bool clearActiveGenre = false,
    bool clearActiveQueryPreset = false,
    bool clearActiveTitle = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      initialMode: initialMode ?? this.initialMode,
      currentMode: currentMode ?? this.currentMode,
      activeGenre: clearActiveGenre ? null : (activeGenre ?? this.activeGenre),
      activeQueryPreset: clearActiveQueryPreset
          ? null
          : (activeQueryPreset ?? this.activeQueryPreset),
      activeTitle: clearActiveTitle ? null : (activeTitle ?? this.activeTitle),
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      tracksErrorMessage: clearTracksError
          ? null
          : (tracksErrorMessage ?? this.tracksErrorMessage),
      usersErrorMessage: clearUsersError
          ? null
          : (usersErrorMessage ?? this.usersErrorMessage),
      playlistsErrorMessage: clearPlaylistsError
          ? null
          : (playlistsErrorMessage ?? this.playlistsErrorMessage),
      paginationErrorMessage: clearPaginationError
          ? null
          : (paginationErrorMessage ?? this.paginationErrorMessage),
      tracks: tracks ?? this.tracks,
      users: users ?? this.users,
      playlists: playlists ?? this.playlists,
      hasMoreTracks: hasMoreTracks ?? this.hasMoreTracks,
      hasMoreUsers: hasMoreUsers ?? this.hasMoreUsers,
      hasMorePlaylists: hasMorePlaylists ?? this.hasMorePlaylists,
      offsetTracks: offsetTracks ?? this.offsetTracks,
      offsetUsers: offsetUsers ?? this.offsetUsers,
      offsetPlaylists: offsetPlaylists ?? this.offsetPlaylists,
    );
  }
}
