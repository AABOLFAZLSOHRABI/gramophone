import 'dart:async';
import 'dart:io';

import '../../../domain/entities/track.dart';
import '../../main/data/datasources/offline_download_data_source.dart';
import '../../main/domain/repositories/main_repository.dart';
import '../../player/data/datasources/player_local_data_source.dart';
import '../../player/data/models/library_playlist_record.dart';
import '../domain/entities/library_playlist.dart';
import '../domain/entities/library_source_type.dart';
import '../domain/entities/library_track.dart';
import '../domain/repositories/library_repository.dart';
import 'datasources/gram_state_data_source.dart';
import 'datasources/library_local_cache_data_source.dart';
import 'datasources/local_media_data_source.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl(
    this._localMedia,
    this._cache,
    MainRepository mainRepository,
    OfflineDownloadDataSource offline,
    PlayerLocalDataSource playerLocal,
  ) : _gram = GramStateDataSource(mainRepository, offline, playerLocal);

  final LocalMediaDataSource _localMedia;
  final LibraryLocalCacheDataSource _cache;
  final GramStateDataSource _gram;

  final StreamController<List<LibraryTrack>> _localCtrl =
      StreamController<List<LibraryTrack>>.broadcast();
  final StreamController<List<LibraryTrack>> _gramDownloadedCtrl =
      StreamController<List<LibraryTrack>>.broadcast();
  final StreamController<List<LibraryTrack>> _gramLikedCtrl =
      StreamController<List<LibraryTrack>>.broadcast();
  final StreamController<List<LibraryTrack>> _gramAllCtrl =
      StreamController<List<LibraryTrack>>.broadcast();
  final StreamController<List<LibraryPlaylist>> _playlistsCtrl =
      StreamController<List<LibraryPlaylist>>.broadcast();
  StreamSubscription<List<Track>>? _likedRealtimeSub;
  StreamSubscription<List<Track>>? _downloadedRealtimeSub;
  StreamSubscription<List<LibraryPlaylistRecord>>? _playlistsRealtimeSub;

  bool _initialized = false;
  List<LibraryTrack> _localTracks = const [];
  List<LibraryTrack> _gramDownloadedTracks = const [];
  List<LibraryTrack> _gramLikedTracks = const [];
  List<LibraryTrack> _gramAllTracks = const [];
  List<LibraryPlaylist> _playlists = const [];

  @override
  Stream<List<LibraryTrack>> watchLocalTracks() async* {
    await _ensureInitialized();
    yield _localTracks;
    yield* _localCtrl.stream;
  }

  @override
  Stream<List<LibraryTrack>> watchGramDownloadedTracks() async* {
    await _ensureInitialized();
    yield _gramDownloadedTracks;
    yield* _gramDownloadedCtrl.stream;
  }

  @override
  Stream<List<LibraryTrack>> watchGramLikedTracks() async* {
    await _ensureInitialized();
    yield _gramLikedTracks;
    yield* _gramLikedCtrl.stream;
  }

  @override
  Stream<List<LibraryPlaylist>> watchGramPlaylists() async* {
    await _ensureInitialized();
    yield _playlists;
    yield* _playlistsCtrl.stream;
  }

  @override
  Stream<List<LibraryTrack>> watchGramAllTracks() async* {
    await _ensureInitialized();
    yield _gramAllTracks;
    yield* _gramAllCtrl.stream;
  }

  @override
  Future<void> scanLocalLibrary({bool pickFoldersOnDesktop = false}) async {
    await _ensureInitialized();
    List<LibraryTrack> tracks;
    if (_isDesktopPlatform()) {
      var folders = await _cache.getDesktopFolders();
      if (pickFoldersOnDesktop || folders.isEmpty) {
        folders = await _localMedia.pickDesktopFolders(
          existingFolders: folders,
        );
        await _cache.saveDesktopFolders(folders);
      }
      tracks = await _localMedia.scanDesktopTracks(folders);
    } else {
      tracks = await _localMedia.scanMobileTracks();
    }

    _localTracks = tracks;
    await _cache.saveLocalTracks(tracks);
    _localCtrl.add(_localTracks);
  }

  @override
  Future<void> refreshGramData() async {
    await _ensureInitialized();
    await _reloadGramState();
  }

  @override
  Future<List<LibraryTrack>> search({
    required LibrarySourceType source,
    required String query,
  }) async {
    await _ensureInitialized();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return source == LibrarySourceType.local ? _localTracks : _gramAllTracks;
    }
    final list = source == LibrarySourceType.local
        ? _localTracks
        : _gramAllTracks;
    return list.where((track) {
      final title = track.title.toLowerCase();
      final artist = track.artist.toLowerCase();
      final album = (track.album ?? '').toLowerCase();
      return title.contains(q) || artist.contains(q) || album.contains(q);
    }).toList();
  }

  @override
  Future<void> toggleLike(String trackId) async {
    Track? target;
    for (final item in [
      ..._gramAllTracks,
      ..._gramDownloadedTracks,
      ..._gramLikedTracks,
    ]) {
      if (item.id == trackId) {
        target = item.toTrack();
        break;
      }
    }
    if (target == null) {
      await _gram.toggleLike(trackId);
    } else {
      await _gram.toggleLikeTrack(target);
    }
    await _reloadGramState();
  }

  @override
  Future<void> addToPlaylist(String trackId, String playlistId) async {
    await _gram.addToPlaylist(trackId, playlistId);
    await _reloadPlaylists();
  }

  @override
  Future<String> createPlaylist(String name) async {
    final id = await _gram.createPlaylist(name);
    await _reloadPlaylists();
    return id;
  }

  @override
  Future<void> renamePlaylist(String id, String name) async {
    await _gram.renamePlaylist(id, name);
    await _reloadPlaylists();
  }

  @override
  Future<void> deletePlaylist(String id) async {
    await _gram.deletePlaylist(id);
    await _reloadPlaylists();
  }

  @override
  Future<List<LibraryTrack>> getTracksForPlaylist(String playlistId) async {
    await _ensureInitialized();
    final ids = await _gram.getPlaylistTrackIds(playlistId);
    final map = <String, LibraryTrack>{
      for (final item in [..._gramAllTracks, ..._gramDownloadedTracks])
        item.id: item,
    };
    return ids.map((id) => map[id]).whereType<LibraryTrack>().toList();
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _localTracks = await _cache.getLocalTracks();
    _localCtrl.add(_localTracks);
    await _likedRealtimeSub?.cancel();
    await _downloadedRealtimeSub?.cancel();
    await _playlistsRealtimeSub?.cancel();
    _likedRealtimeSub = _gram.watchLikedTracks().listen((_) {
      _reloadGramState();
    });
    _downloadedRealtimeSub = _gram.watchDownloadedTracks().listen((_) {
      _reloadGramState();
    });
    _playlistsRealtimeSub = _gram.watchPlaylists().listen((_) {
      _reloadPlaylists();
    });
    await _reloadGramState();
  }

  Future<void> _reloadGramState() async {
    final all = await _gram.getAllGramTracks();
    final downloaded = await _gram.getDownloadedTracks();
    final likedTracks = await _gram.getLikedTracks();
    final likedSet = likedTracks.map((item) => item.id).toSet();

    _gramAllTracks = [...all, ...likedTracks]
        .fold<Map<String, Track>>({}, (acc, item) {
          acc[item.id] = item;
          return acc;
        })
        .values
        .map((item) => _mapTrack(item, likedSet))
        .toList();
    _gramDownloadedTracks = downloaded
        .map((item) => _mapTrack(item, likedSet, isDownloaded: true))
        .toList();
    _gramLikedTracks = likedTracks
        .map((item) => _mapTrack(item, likedSet))
        .toList();

    await _reloadPlaylists();
    _gramAllCtrl.add(_gramAllTracks);
    _gramDownloadedCtrl.add(_gramDownloadedTracks);
    _gramLikedCtrl.add(_gramLikedTracks);
  }

  Future<void> _reloadPlaylists() async {
    final raw = await _gram.getPlaylists();
    _playlists = raw
        .map(
          (item) => LibraryPlaylist(
            id: item.id,
            name: item.name,
            trackIds: item.trackIds,
            createdAt: item.createdAt,
            updatedAt: item.updatedAt,
          ),
        )
        .toList();
    _playlistsCtrl.add(_playlists);
  }

  LibraryTrack _mapTrack(
    Track source,
    Set<String> likedIds, {
    bool isDownloaded = false,
  }) {
    return LibraryTrack(
      id: source.id,
      title: source.title,
      artist: source.artist,
      imageUrl: source.imageUrl,
      duration: source.duration,
      streamUrl: source.streamUrl,
      localPath: isDownloaded ? source.streamUrl : null,
      dateAdded: DateTime.now(),
      isDownloaded: isDownloaded,
      isLiked: likedIds.contains(source.id),
    );
  }

  bool _isDesktopPlatform() {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
}
