import 'package:gramophone/domain/entities/track.dart';

abstract class PlayerRepository {
  Future<String?> getLocalAudioPath(String trackId);
  Future<bool> isTrackDownloaded(String trackId);
  Future<void> downloadTrack(Track track);
  Future<bool> isLiked(String trackId);
  Future<void> toggleLike(String trackId);
  Future<void> addToPlaylist(String trackId, {String? playlistId});
  Future<List<Track>> getOfflineTracks();
}
