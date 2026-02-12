import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/data/datasources/offline_download_data_source.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/features/player/data/datasources/player_local_data_source.dart';
import 'package:gramophone/features/player/domain/repositories/player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl(this._mainRepository, this._offline, this._local);

  final MainRepository _mainRepository;
  final OfflineDownloadDataSource _offline;
  final PlayerLocalDataSource _local;

  @override
  Future<String?> getLocalAudioPath(String trackId) {
    return _offline.getDownloadedAudioPath(trackId);
  }

  @override
  Future<bool> isTrackDownloaded(String trackId) async {
    final result = await _mainRepository.isTrackDownloaded(trackId);
    switch (result) {
      case ResultSuccess<bool>():
        return result.data;
      case ResultFailure<bool>():
        return false;
    }
  }

  @override
  Future<void> downloadTrack(Track track) async {
    final result = await _mainRepository.downloadTrack(track);
    switch (result) {
      case ResultSuccess<void>():
        return;
      case ResultFailure<void>():
        throw StateError(result.failure.message);
    }
  }

  @override
  Future<bool> isLiked(String trackId) => _local.isLiked(trackId);

  @override
  Future<void> toggleLike(String trackId) => _local.toggleLike(trackId);

  @override
  Future<void> addToPlaylist(String trackId, {String? playlistId}) {
    return _local.addToPlaylist(trackId, playlistId: playlistId);
  }

  @override
  Future<List<Track>> getOfflineTracks() async {
    final result = await _mainRepository.watchOfflineTracks().first;
    switch (result) {
      case ResultSuccess<List<Track>>():
        return result.data;
      case ResultFailure<List<Track>>():
        return const [];
    }
  }
}
