import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/library_playlist.dart';
import '../../domain/entities/library_section.dart';
import '../../domain/entities/library_sort.dart';
import '../../domain/entities/library_source_type.dart';
import '../../domain/entities/library_track.dart';
import '../../domain/repositories/library_repository.dart';
import 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit(this._repository) : super(const LibraryState.initial());

  final LibraryRepository _repository;
  StreamSubscription<List<LibraryTrack>>? _localSub;
  StreamSubscription<List<LibraryTrack>>? _gramSub;
  StreamSubscription<List<LibraryTrack>>? _downloadedSub;
  StreamSubscription<List<LibraryTrack>>? _likedSub;
  StreamSubscription<List<LibraryPlaylist>>? _playlistsSub;
  Timer? _searchDebounce;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true, clearInfo: true));
    await _localSub?.cancel();
    await _gramSub?.cancel();
    await _downloadedSub?.cancel();
    await _likedSub?.cancel();
    await _playlistsSub?.cancel();

    _localSub = _repository.watchLocalTracks().listen((items) {
      emit(state.copyWith(localTracks: items, isLoading: false));
    });
    _gramSub = _repository.watchGramAllTracks().listen((items) {
      emit(state.copyWith(gramTracks: items, isLoading: false));
    });
    _downloadedSub = _repository.watchGramDownloadedTracks().listen((items) {
      emit(state.copyWith(downloadedTracks: items, isLoading: false));
    });
    _likedSub = _repository.watchGramLikedTracks().listen((items) {
      emit(state.copyWith(likedTracks: items, isLoading: false));
    });
    _playlistsSub = _repository.watchGramPlaylists().listen((items) {
      emit(state.copyWith(playlists: items, isLoading: false));
    });

    try {
      await _repository.refreshGramData();
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
          clearInfo: true,
        ),
      );
    }
  }

  void setSource(LibrarySourceType source) {
    emit(
      state.copyWith(
        source: source,
        section: LibrarySection.allTracks,
        clearError: true,
      ),
    );
  }

  void setSection(LibrarySection section) {
    emit(state.copyWith(section: section, clearError: true));
  }

  void setSort(LibrarySort sort) {
    emit(state.copyWith(sort: sort));
  }

  void setQuery(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      emit(state.copyWith(query: query));
    });
  }

  Future<void> scanLocal({bool pickFoldersOnDesktop = false}) async {
    emit(
      state.copyWith(
        isScanning: true,
        scanProgress: 0.1,
        clearError: true,
        clearInfo: true,
      ),
    );
    try {
      await _repository.scanLocalLibrary(
        pickFoldersOnDesktop: pickFoldersOnDesktop,
      );
      emit(
        state.copyWith(
          isScanning: false,
          scanProgress: 1,
          infoMessage: 'Local library synced.',
          source: LibrarySourceType.local,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isScanning: false,
          scanProgress: 0,
          errorMessage: error.toString(),
          clearInfo: true,
        ),
      );
    }
  }

  Future<void> refreshGram() async {
    emit(state.copyWith(isLoading: true, clearError: true, clearInfo: true));
    try {
      await _repository.refreshGramData();
      emit(
        state.copyWith(
          isLoading: false,
          source: LibrarySourceType.gram,
          infoMessage: 'Gram library refreshed.',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error.toString(),
          clearInfo: true,
        ),
      );
    }
  }

  Future<void> toggleLike(String trackId) async {
    try {
      await _repository.toggleLike(trackId);
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearInfo: true));
    }
  }

  Future<void> addToPlaylist(String trackId, String playlistId) async {
    try {
      await _repository.addToPlaylist(trackId, playlistId);
      emit(state.copyWith(infoMessage: 'Added to playlist.', clearError: true));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearInfo: true));
    }
  }

  Future<void> createPlaylist(String name) async {
    if (name.trim().isEmpty) {
      return;
    }
    try {
      await _repository.createPlaylist(name.trim());
      emit(state.copyWith(infoMessage: 'Playlist created.', clearError: true));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearInfo: true));
    }
  }

  Future<void> renamePlaylist(String id, String name) async {
    if (name.trim().isEmpty) {
      return;
    }
    try {
      await _repository.renamePlaylist(id, name.trim());
      emit(state.copyWith(infoMessage: 'Playlist renamed.', clearError: true));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearInfo: true));
    }
  }

  Future<void> deletePlaylist(String id) async {
    try {
      await _repository.deletePlaylist(id);
      emit(state.copyWith(infoMessage: 'Playlist deleted.', clearError: true));
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString(), clearInfo: true));
    }
  }

  Future<List<LibraryTrack>> getTracksForPlaylist(String playlistId) {
    return _repository.getTracksForPlaylist(playlistId);
  }

  void clearMessage() {
    emit(state.copyWith(clearError: true, clearInfo: true));
  }

  @override
  Future<void> close() async {
    _searchDebounce?.cancel();
    await _localSub?.cancel();
    await _gramSub?.cancel();
    await _downloadedSub?.cancel();
    await _likedSub?.cancel();
    await _playlistsSub?.cancel();
    return super.close();
  }
}
