import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/domain/models/player_playlist.dart';

abstract class PlayerRepository {
  Future<String?> getLocalAudioPath(String trackId);
  Future<bool> isTrackDownloaded(String trackId);
  Future<void> downloadTrack(Track track);
  Stream<List<Track>> watchDownloadedTracks();
  Future<bool> isLiked(String trackId);
  Future<void> toggleLike(String trackId);
  Future<void> toggleLikeTrack(Track track);
  Future<List<Track>> getLikedTracks();
  Stream<List<Track>> watchLikedTracks();
  Future<void> addToPlaylist(String trackId, {String? playlistId});
  Future<List<PlayerPlaylist>> getPlaylists();
  Stream<List<PlayerPlaylist>> watchPlaylists();
  Future<String> createPlaylist(String name);
  Future<List<Track>> getOfflineTracks();
}
