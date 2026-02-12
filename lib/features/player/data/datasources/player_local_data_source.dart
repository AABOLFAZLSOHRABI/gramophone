import 'package:hive_ce_flutter/hive_flutter.dart';

class PlayerLocalDataSource {
  static const likesBoxName = 'likes_box';
  static const playlistsBoxName = 'playlists_box';
  static const defaultPlaylistId = 'default_playlist';

  Box<dynamic> get _likesBox => Hive.box<dynamic>(likesBoxName);
  Box<dynamic> get _playlistsBox => Hive.box<dynamic>(playlistsBoxName);

  Future<bool> isLiked(String trackId) async {
    final raw = _likesBox.get(trackId);
    return raw is bool ? raw : false;
  }

  Future<void> toggleLike(String trackId) async {
    final liked = await isLiked(trackId);
    await _likesBox.put(trackId, !liked);
  }

  Future<void> addToPlaylist(String trackId, {String? playlistId}) async {
    final id = (playlistId == null || playlistId.isEmpty)
        ? defaultPlaylistId
        : playlistId;
    final raw = _playlistsBox.get(id);
    final items = raw is List ? List<String>.from(raw) : <String>[];

    if (!items.contains(trackId)) {
      items.add(trackId);
      await _playlistsBox.put(id, items);
    }
  }
}
