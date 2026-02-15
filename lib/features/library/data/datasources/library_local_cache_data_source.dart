import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../domain/entities/library_track.dart';

class LibraryLocalCacheDataSource {
  static const localLibraryBoxName = 'local_library_cache_box';
  static const localFoldersKey = 'desktop_music_folders';
  static const localTracksKey = 'local_tracks';

  Box<dynamic> get _box => Hive.box<dynamic>(localLibraryBoxName);

  Future<void> saveLocalTracks(List<LibraryTrack> tracks) async {
    await _box.put(localTracksKey, tracks.map((item) => item.toMap()).toList());
  }

  Future<List<LibraryTrack>> getLocalTracks() async {
    final raw = _box.get(localTracksKey);
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map>()
        .map((item) => LibraryTrack.fromMap(item))
        .where((track) => track.id.isNotEmpty)
        .toList();
  }

  Future<void> saveDesktopFolders(List<String> folders) async {
    await _box.put(localFoldersKey, folders);
  }

  Future<List<String>> getDesktopFolders() async {
    final raw = _box.get(localFoldersKey);
    if (raw is! List) {
      return const [];
    }
    return raw.map((item) => item.toString()).toList();
  }
}
