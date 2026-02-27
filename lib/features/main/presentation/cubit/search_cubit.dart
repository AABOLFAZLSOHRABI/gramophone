import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/domain/entities/search_playlist.dart';
import 'package:gramophone/domain/entities/search_user.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';

import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(const SearchState.initial());

  static const int _pageSize = 20;
  static const Duration _debounceDuration = Duration(milliseconds: 350);

  final MainRepository _repository;
  Timer? _searchDebounce;
  int _requestToken = 0;
  bool _loadingMoreTracks = false;
  bool _loadingMoreUsers = false;
  bool _loadingMorePlaylists = false;

  void onQueryChanged(String value) {
    final query = value.trim();
    _searchDebounce?.cancel();
    if (query.length < 2) {
      _requestToken++;
      emit(
        const SearchState.initial().copyWith(
          query: query,
          clearError: true,
          clearTracksError: true,
          clearUsersError: true,
          clearPlaylistsError: true,
          clearPaginationError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        query: query,
        initialMode: state.initialMode,
        currentMode: SearchPresetMode.text,
        clearActiveGenre: true,
        clearActiveQueryPreset: true,
        clearActiveTitle: true,
        clearError: true,
        clearTracksError: true,
        clearUsersError: true,
        clearPlaylistsError: true,
        clearPaginationError: true,
      ),
    );
    _searchDebounce = Timer(_debounceDuration, _searchInitial);
  }

  Future<void> retry() async {
    switch (state.currentMode) {
      case SearchPresetMode.genreTrending:
        final genre = state.activeGenre;
        if (genre == null || genre.isEmpty) {
          return;
        }
        await loadTrendingByGenre(
          genre: genre,
          title: state.activeTitle ?? genre,
        );
        return;
      case SearchPresetMode.tracksTrending:
        await loadTrendingAll(title: state.activeTitle ?? 'Charts');
        return;
      case SearchPresetMode.tracksUnderground:
        await loadUndergroundTrending(
          title: state.activeTitle ?? 'Underground',
        );
        return;
      case SearchPresetMode.feelingLucky:
        await loadFeelingLucky(title: state.activeTitle ?? 'Made for you');
        return;
      case SearchPresetMode.playlistSearch:
        final preset = state.activeQueryPreset;
        if (preset == null || preset.isEmpty) {
          return;
        }
        await loadPlaylistSearchPreset(
          query: preset,
          title: state.activeTitle ?? preset,
        );
        return;
      case SearchPresetMode.text:
        if (state.query.length < 2) {
          return;
        }
        await _searchInitial();
        return;
    }
  }

  Future<void> loadTrendingByGenre({
    required String genre,
    String time = 'week',
    String? title,
  }) async {
    final normalizedGenre = genre.trim();
    if (normalizedGenre.isEmpty) {
      return;
    }
    _searchDebounce?.cancel();
    final requestToken = ++_requestToken;
    emit(
      state.copyWith(
        query: normalizedGenre,
        initialMode: SearchPresetMode.genreTrending,
        currentMode: SearchPresetMode.genreTrending,
        activeGenre: normalizedGenre,
        activeTitle: title ?? normalizedGenre,
        clearActiveQueryPreset: true,
        isLoadingInitial: true,
        clearError: true,
        clearTracksError: true,
        clearUsersError: true,
        clearPlaylistsError: true,
        clearPaginationError: true,
        tracks: const [],
        users: const [],
        playlists: const [],
        hasMoreTracks: false,
        hasMoreUsers: false,
        hasMorePlaylists: false,
        offsetTracks: 0,
        offsetUsers: 0,
        offsetPlaylists: 0,
      ),
    );

    final result = await _repository.getTrendingTracksFromApi(
      genre: normalizedGenre,
      time: time,
      limit: _pageSize,
      offset: 0,
    );

    if (requestToken != _requestToken || isClosed) {
      return;
    }

    _emitTrackPresetResult(result);
  }

  Future<void> loadTrendingAll({String time = 'week', String? title}) async {
    _searchDebounce?.cancel();
    final requestToken = ++_requestToken;
    emit(
      state.copyWith(
        query: title ?? '',
        initialMode: SearchPresetMode.tracksTrending,
        currentMode: SearchPresetMode.tracksTrending,
        activeTitle: title ?? 'Charts',
        clearActiveGenre: true,
        clearActiveQueryPreset: true,
        isLoadingInitial: true,
        clearError: true,
        clearTracksError: true,
        clearUsersError: true,
        clearPlaylistsError: true,
        clearPaginationError: true,
        tracks: const [],
        users: const [],
        playlists: const [],
        hasMoreTracks: false,
        hasMoreUsers: false,
        hasMorePlaylists: false,
        offsetTracks: 0,
        offsetUsers: 0,
        offsetPlaylists: 0,
      ),
    );

    final result = await _repository.getTrendingTracksFromApi(
      time: time,
      limit: _pageSize,
      offset: 0,
    );

    if (requestToken != _requestToken || isClosed) {
      return;
    }

    _emitTrackPresetResult(result);
  }

  Future<void> loadUndergroundTrending({String? title}) async {
    _searchDebounce?.cancel();
    final requestToken = ++_requestToken;
    emit(
      state.copyWith(
        query: title ?? '',
        initialMode: SearchPresetMode.tracksUnderground,
        currentMode: SearchPresetMode.tracksUnderground,
        activeTitle: title ?? 'Underground',
        clearActiveGenre: true,
        clearActiveQueryPreset: true,
        isLoadingInitial: true,
        clearError: true,
        clearTracksError: true,
        clearUsersError: true,
        clearPlaylistsError: true,
        clearPaginationError: true,
        tracks: const [],
        users: const [],
        playlists: const [],
        hasMoreTracks: false,
        hasMoreUsers: false,
        hasMorePlaylists: false,
        offsetTracks: 0,
        offsetUsers: 0,
        offsetPlaylists: 0,
      ),
    );

    final result = await _repository.getUndergroundTrendingTracksFromApi(
      limit: _pageSize,
      offset: 0,
    );

    if (requestToken != _requestToken || isClosed) {
      return;
    }

    _emitTrackPresetResult(result);
  }

  Future<void> loadFeelingLucky({String? title}) async {
    _searchDebounce?.cancel();
    final requestToken = ++_requestToken;
    emit(
      state.copyWith(
        query: title ?? '',
        initialMode: SearchPresetMode.feelingLucky,
        currentMode: SearchPresetMode.feelingLucky,
        activeTitle: title ?? 'Made for you',
        clearActiveGenre: true,
        clearActiveQueryPreset: true,
        isLoadingInitial: true,
        clearError: true,
        clearTracksError: true,
        clearUsersError: true,
        clearPlaylistsError: true,
        clearPaginationError: true,
        tracks: const [],
        users: const [],
        playlists: const [],
        hasMoreTracks: false,
        hasMoreUsers: false,
        hasMorePlaylists: false,
        offsetTracks: 0,
        offsetUsers: 0,
        offsetPlaylists: 0,
      ),
    );

    final result = await _repository.getFeelingLuckyTracksFromApi(
      limit: _pageSize,
    );

    if (requestToken != _requestToken || isClosed) {
      return;
    }

    _emitTrackPresetResult(result, allowPagination: false);
  }

  Future<void> loadPlaylistSearchPreset({
    required String query,
    String? title,
  }) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return;
    }
    _searchDebounce?.cancel();
    final requestToken = ++_requestToken;
    emit(
      state.copyWith(
        query: normalizedQuery,
        initialMode: SearchPresetMode.playlistSearch,
        currentMode: SearchPresetMode.playlistSearch,
        activeQueryPreset: normalizedQuery,
        activeTitle: title ?? normalizedQuery,
        clearActiveGenre: true,
        isLoadingInitial: true,
        clearError: true,
        clearTracksError: true,
        clearUsersError: true,
        clearPlaylistsError: true,
        clearPaginationError: true,
        tracks: const [],
        users: const [],
        playlists: const [],
        hasMoreTracks: false,
        hasMoreUsers: false,
        hasMorePlaylists: false,
        offsetTracks: 0,
        offsetUsers: 0,
        offsetPlaylists: 0,
      ),
    );

    final result = await _repository.searchPlaylists(
      query: normalizedQuery,
      limit: _pageSize,
      offset: 0,
    );

    if (requestToken != _requestToken || isClosed) {
      return;
    }

    switch (result) {
      case ResultSuccess<List<SearchPlaylist>>():
        final playlists = result.data;
        emit(
          state.copyWith(
            isLoadingInitial: false,
            tracks: const [],
            users: const [],
            playlists: playlists,
            hasMoreTracks: false,
            hasMoreUsers: false,
            hasMorePlaylists: playlists.length >= _pageSize,
            offsetTracks: 0,
            offsetUsers: 0,
            offsetPlaylists: playlists.length,
          ),
        );
      case ResultFailure<List<SearchPlaylist>>():
        emit(
          state.copyWith(
            isLoadingInitial: false,
            errorMessage: result.failure.message,
            playlistsErrorMessage: result.failure.message,
            tracks: const [],
            users: const [],
          ),
        );
    }
  }

  Future<void> _searchInitial() async {
    final query = state.query.trim();
    if (query.length < 2) {
      return;
    }
    final requestToken = ++_requestToken;
    emit(
      state.copyWith(
        initialMode: state.initialMode,
        currentMode: SearchPresetMode.text,
        clearActiveGenre: true,
        clearActiveQueryPreset: true,
        clearActiveTitle: true,
        isLoadingInitial: true,
        clearError: true,
        clearTracksError: true,
        clearUsersError: true,
        clearPlaylistsError: true,
        clearPaginationError: true,
        tracks: const [],
        users: const [],
        playlists: const [],
        hasMoreTracks: false,
        hasMoreUsers: false,
        hasMorePlaylists: false,
        offsetTracks: 0,
        offsetUsers: 0,
        offsetPlaylists: 0,
      ),
    );

    final results = await Future.wait([
      _repository.searchTracks(query: query, limit: _pageSize, offset: 0),
      _repository.searchUsers(query: query, limit: _pageSize, offset: 0),
      _repository.searchPlaylists(query: query, limit: _pageSize, offset: 0),
    ]);

    if (requestToken != _requestToken || isClosed) {
      return;
    }

    final tracksResult = results[0] as Result<List<Track>>;
    final usersResult = results[1] as Result<List<SearchUser>>;
    final playlistsResult = results[2] as Result<List<SearchPlaylist>>;

    var tracks = const <Track>[];
    var users = const <SearchUser>[];
    var playlists = const <SearchPlaylist>[];
    String? tracksError;
    String? usersError;
    String? playlistsError;
    String? blockingError;

    switch (tracksResult) {
      case ResultSuccess<List<Track>>():
        tracks = tracksResult.data;
      case ResultFailure<List<Track>>():
        tracksError = tracksResult.failure.message;
    }

    switch (usersResult) {
      case ResultSuccess<List<SearchUser>>():
        users = usersResult.data;
      case ResultFailure<List<SearchUser>>():
        usersError = usersResult.failure.message;
    }

    switch (playlistsResult) {
      case ResultSuccess<List<SearchPlaylist>>():
        playlists = playlistsResult.data;
      case ResultFailure<List<SearchPlaylist>>():
        playlistsError = playlistsResult.failure.message;
    }

    if (tracks.isEmpty && users.isEmpty && playlists.isEmpty) {
      blockingError = tracksError ?? usersError ?? playlistsError;
    }

    emit(
      state.copyWith(
        isLoadingInitial: false,
        errorMessage: blockingError,
        tracksErrorMessage: tracksError,
        usersErrorMessage: usersError,
        playlistsErrorMessage: playlistsError,
        tracks: tracks,
        users: users,
        playlists: playlists,
        hasMoreTracks: tracks.length >= _pageSize,
        hasMoreUsers: users.length >= _pageSize,
        hasMorePlaylists: playlists.length >= _pageSize,
        offsetTracks: tracks.length,
        offsetUsers: users.length,
        offsetPlaylists: playlists.length,
      ),
    );
  }

  Future<void> loadMoreTracks() async {
    if (_loadingMoreTracks || !state.hasMoreTracks || state.query.length < 2) {
      return;
    }
    _loadingMoreTracks = true;
    _updateIsLoadingMore();

    final result = await switch (state.currentMode) {
      SearchPresetMode.genreTrending => _repository.getTrendingTracksFromApi(
        genre: state.activeGenre,
        time: 'week',
        limit: _pageSize,
        offset: state.offsetTracks,
      ),
      SearchPresetMode.tracksTrending => _repository.getTrendingTracksFromApi(
        time: 'week',
        limit: _pageSize,
        offset: state.offsetTracks,
      ),
      SearchPresetMode.tracksUnderground =>
        _repository.getUndergroundTrendingTracksFromApi(
          limit: _pageSize,
          offset: state.offsetTracks,
        ),
      SearchPresetMode.feelingLucky => Future<Result<List<Track>>>.value(
        const ResultSuccess(<Track>[]),
      ),
      _ => _repository.searchTracks(
        query: state.query,
        limit: _pageSize,
        offset: state.offsetTracks,
      ),
    };

    switch (result) {
      case ResultSuccess<List<Track>>():
        final items = result.data;
        emit(
          state.copyWith(
            tracks: List<Track>.from(state.tracks)..addAll(items),
            hasMoreTracks: state.currentMode == SearchPresetMode.feelingLucky
                ? false
                : items.length >= _pageSize,
            offsetTracks: state.offsetTracks + items.length,
            clearPaginationError: true,
          ),
        );
      case ResultFailure<List<Track>>():
        emit(
          state.copyWith(
            paginationErrorMessage: result.failure.message,
            tracksErrorMessage: result.failure.message,
          ),
        );
    }
    _loadingMoreTracks = false;
    _updateIsLoadingMore();
  }

  Future<void> loadMoreUsers() async {
    if (state.currentMode != SearchPresetMode.text ||
        _loadingMoreUsers ||
        !state.hasMoreUsers ||
        state.query.length < 2) {
      return;
    }
    _loadingMoreUsers = true;
    _updateIsLoadingMore();
    final result = await _repository.searchUsers(
      query: state.query,
      limit: _pageSize,
      offset: state.offsetUsers,
    );
    switch (result) {
      case ResultSuccess<List<SearchUser>>():
        final items = result.data;
        emit(
          state.copyWith(
            users: List<SearchUser>.from(state.users)..addAll(items),
            hasMoreUsers: items.length >= _pageSize,
            offsetUsers: state.offsetUsers + items.length,
            clearPaginationError: true,
          ),
        );
      case ResultFailure<List<SearchUser>>():
        emit(
          state.copyWith(
            paginationErrorMessage: result.failure.message,
            usersErrorMessage: result.failure.message,
          ),
        );
    }
    _loadingMoreUsers = false;
    _updateIsLoadingMore();
  }

  Future<void> loadMorePlaylists() async {
    if (_loadingMorePlaylists ||
        !state.hasMorePlaylists ||
        state.query.length < 2) {
      return;
    }

    if (state.currentMode != SearchPresetMode.text &&
        state.currentMode != SearchPresetMode.playlistSearch) {
      return;
    }

    _loadingMorePlaylists = true;
    _updateIsLoadingMore();

    final result = await _repository.searchPlaylists(
      query: state.currentMode == SearchPresetMode.playlistSearch
          ? (state.activeQueryPreset ?? state.query)
          : state.query,
      limit: _pageSize,
      offset: state.offsetPlaylists,
    );
    switch (result) {
      case ResultSuccess<List<SearchPlaylist>>():
        final items = result.data;
        emit(
          state.copyWith(
            playlists: List<SearchPlaylist>.from(state.playlists)
              ..addAll(items),
            hasMorePlaylists: items.length >= _pageSize,
            offsetPlaylists: state.offsetPlaylists + items.length,
            clearPaginationError: true,
          ),
        );
      case ResultFailure<List<SearchPlaylist>>():
        emit(
          state.copyWith(
            paginationErrorMessage: result.failure.message,
            playlistsErrorMessage: result.failure.message,
          ),
        );
    }
    _loadingMorePlaylists = false;
    _updateIsLoadingMore();
  }

  void clearPaginationError() {
    emit(state.copyWith(clearPaginationError: true));
  }

  void _emitTrackPresetResult(
    Result<List<Track>> result, {
    bool allowPagination = true,
  }) {
    switch (result) {
      case ResultSuccess<List<Track>>():
        final tracks = result.data;
        emit(
          state.copyWith(
            isLoadingInitial: false,
            tracks: tracks,
            users: const [],
            playlists: const [],
            hasMoreTracks: allowPagination && tracks.length >= _pageSize,
            hasMoreUsers: false,
            hasMorePlaylists: false,
            offsetTracks: tracks.length,
            offsetUsers: 0,
            offsetPlaylists: 0,
          ),
        );
      case ResultFailure<List<Track>>():
        emit(
          state.copyWith(
            isLoadingInitial: false,
            errorMessage: result.failure.message,
            tracksErrorMessage: result.failure.message,
            users: const [],
            playlists: const [],
          ),
        );
    }
  }

  void _updateIsLoadingMore() {
    emit(
      state.copyWith(
        isLoadingMore:
            _loadingMoreTracks || _loadingMoreUsers || _loadingMorePlaylists,
      ),
    );
  }

  @override
  Future<void> close() async {
    _searchDebounce?.cancel();
    return super.close();
  }
}
