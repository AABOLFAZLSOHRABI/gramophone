import '../../../../core/result/result.dart';
import '../../../../domain/entities/review_item.dart';
import '../../../../domain/entities/track.dart';
import '../../../main/data/datasources/offline_download_data_source.dart';
import '../../../main/domain/repositories/main_repository.dart';
import '../../../player/data/datasources/player_local_data_source.dart';
import '../../../player/data/models/library_playlist_record.dart';

class GramStateDataSource {
  GramStateDataSource(this._mainRepository, this._offline, this._playerLocal);

  final MainRepository _mainRepository;
  final OfflineDownloadDataSource _offline;
  final PlayerLocalDataSource _playerLocal;

  Future<List<Track>> getAllGramTracks() async {
    final calls = await Future.wait([
      _mainRepository.getTrendingTracksFromApi(time: 'week', limit: 50),
      _mainRepository.getTrendingTracksFromApi(time: 'allTime', limit: 50),
    ]);

    final map = <String, Track>{};
    for (final result in calls) {
      if (result is ResultSuccess<List<Track>>) {
        for (final track in result.data) {
          map[track.id] = track;
        }
      }
    }

    final reviews = await _mainRepository.getReviewItemsFromApi(limit: 20);
    if (reviews is ResultSuccess<List<ReviewItem>>) {
      for (final item in reviews.data) {
        for (final track in item.tracks) {
          map[track.id] = track;
        }
      }
    }

    return map.values.toList();
  }

  Future<List<Track>> getDownloadedTracks() async {
    final records = await _offline.getDownloadedTracks();
    return records.map((item) => item.toEntity()).toList();
  }

  Future<List<String>> getLikedTrackIds() {
    return _playerLocal.getLikedTrackIds();
  }

  Future<List<Track>> getLikedTracks() {
    return _playerLocal.getLikedTracks();
  }

  Stream<List<Track>> watchLikedTracks() {
    return _playerLocal.watchLikedTracks();
  }

  Stream<List<Track>> watchDownloadedTracks() async* {
    await for (final records in _offline.watchDownloadedTracks()) {
      yield records.map((item) => item.toEntity()).toList();
    }
  }

  Stream<List<LibraryPlaylistRecord>> watchPlaylists() {
    return _playerLocal.watchPlaylists();
  }

  Future<List<LibraryPlaylistRecord>> getPlaylists() {
    return _playerLocal.getPlaylists();
  }

  Future<void> toggleLike(String trackId) {
    return _playerLocal.toggleLike(trackId);
  }

  Future<void> toggleLikeTrack(Track track) {
    return _playerLocal.toggleLikeTrack(track);
  }

  Future<void> addToPlaylist(String trackId, String playlistId) {
    return _playerLocal.addToPlaylist(trackId, playlistId: playlistId);
  }

  Future<String> createPlaylist(String name) {
    return _playerLocal.createPlaylist(name);
  }

  Future<void> renamePlaylist(String id, String name) {
    return _playerLocal.renamePlaylist(id, name);
  }

  Future<void> deletePlaylist(String id) {
    return _playerLocal.deletePlaylist(id);
  }

  Future<List<String>> getPlaylistTrackIds(String id) {
    return _playerLocal.getPlaylistTrackIds(id);
  }
}
