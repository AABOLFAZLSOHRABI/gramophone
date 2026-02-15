import 'dart:async';

import 'package:gramophone/domain/entities/track.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/library_playlist_record.dart';
import '../models/liked_track_record.dart';

class PlayerLocalDataSource {
  static const likesBoxName = 'likes_box';
  static const playlistsBoxName = 'playlists_box';
  static const defaultPlaylistId = 'default_playlist';
  static const defaultPlaylistName = 'My Playlist';

  final StreamController<List<Track>> _likedController =
      StreamController<List<Track>>.broadcast();
  final StreamController<List<LibraryPlaylistRecord>> _playlistsController =
      StreamController<List<LibraryPlaylistRecord>>.broadcast();

  Box<dynamic> get _likesBox => Hive.box<dynamic>(likesBoxName);
  Box<dynamic> get _playlistsBox => Hive.box<dynamic>(playlistsBoxName);

  Future<bool> isLiked(String trackId) async {
    final raw = _likesBox.get(trackId);
    if (raw is bool) {
      return raw;
    }
    if (raw is Map) {
      return (raw['liked'] as bool?) ?? true;
    }
    return false;
  }

  Future<void> toggleLike(String trackId) async {
    final currentlyLiked = await isLiked(trackId);
    if (currentlyLiked) {
      await _likesBox.delete(trackId);
    } else {
      final minimal = LikedTrackRecord(
        liked: true,
        updatedAt: DateTime.now(),
        track: Track(
          id: trackId,
          title: 'Unknown title',
          artist: 'Unknown artist',
        ),
      );
      await _likesBox.put(trackId, minimal.toMap());
    }
    await _emitLiked();
  }

  Future<void> toggleLikeTrack(Track track) async {
    final currentlyLiked = await isLiked(track.id);
    if (currentlyLiked) {
      await _likesBox.delete(track.id);
    } else {
      final record = LikedTrackRecord(
        liked: true,
        updatedAt: DateTime.now(),
        track: track,
      );
      await _likesBox.put(track.id, record.toMap());
    }
    await _emitLiked();
  }

  Future<List<String>> getLikedTrackIds() async {
    final liked = await getLikedTracks();
    return liked.map((item) => item.id).toList();
  }

  Future<List<Track>> getLikedTracks() async {
    final result = <Track>[];
    for (final key in _likesBox.keys) {
      final raw = _likesBox.get(key);
      if (raw is bool) {
        if (raw) {
          result.add(
            Track(
              id: key.toString(),
              title: 'Unknown title',
              artist: 'Unknown artist',
            ),
          );
        }
        continue;
      }
      if (raw is! Map) {
        continue;
      }
      final record = LikedTrackRecord.fromMap(raw);
      if (record.liked) {
        result.add(record.track);
      }
    }
    return result;
  }

  Stream<List<Track>> watchLikedTracks() async* {
    await _migrateLegacyLikesIfNeeded();
    yield await getLikedTracks();
    yield* _likedController.stream;
  }

  Future<void> addToPlaylist(String trackId, {String? playlistId}) async {
    final id = (playlistId == null || playlistId.isEmpty)
        ? defaultPlaylistId
        : playlistId;
    final playlists = await getPlaylists();
    LibraryPlaylistRecord? target;
    for (final item in playlists) {
      if (item.id == id) {
        target = item;
        break;
      }
    }
    final fallback =
        target ??
        LibraryPlaylistRecord(
          id: id,
          name: id == defaultPlaylistId ? defaultPlaylistName : id,
          trackIds: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
    if (fallback.trackIds.contains(trackId)) {
      return;
    }
    final updated = LibraryPlaylistRecord(
      id: fallback.id,
      name: fallback.name,
      trackIds: [...fallback.trackIds, trackId],
      createdAt: fallback.createdAt,
      updatedAt: DateTime.now(),
    );
    await _playlistsBox.put(id, updated.toMap());
    await _emitPlaylists();
  }

  Future<List<LibraryPlaylistRecord>> getPlaylists() async {
    await _migrateLegacyPlaylistsIfNeeded();
    final playlists = <LibraryPlaylistRecord>[];
    for (final key in _playlistsBox.keys) {
      final raw = _playlistsBox.get(key);
      if (raw is! Map) {
        continue;
      }
      playlists.add(LibraryPlaylistRecord.fromMap(raw));
    }
    playlists.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return playlists;
  }

  Stream<List<LibraryPlaylistRecord>> watchPlaylists() async* {
    await _migrateLegacyPlaylistsIfNeeded();
    yield await getPlaylists();
    yield* _playlistsController.stream;
  }

  Future<String> createPlaylist(String name) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final now = DateTime.now();
    final playlist = LibraryPlaylistRecord(
      id: id,
      name: name.trim(),
      trackIds: const [],
      createdAt: now,
      updatedAt: now,
    );
    await _playlistsBox.put(id, playlist.toMap());
    await _emitPlaylists();
    return id;
  }

  Future<void> renamePlaylist(String id, String name) async {
    final raw = _playlistsBox.get(id);
    if (raw is! Map) {
      return;
    }
    final playlist = LibraryPlaylistRecord.fromMap(raw);
    final updated = LibraryPlaylistRecord(
      id: playlist.id,
      name: name.trim(),
      trackIds: playlist.trackIds,
      createdAt: playlist.createdAt,
      updatedAt: DateTime.now(),
    );
    await _playlistsBox.put(id, updated.toMap());
    await _emitPlaylists();
  }

  Future<void> deletePlaylist(String id) async {
    if (id == defaultPlaylistId) {
      return;
    }
    await _playlistsBox.delete(id);
    await _emitPlaylists();
  }

  Future<List<String>> getPlaylistTrackIds(String id) async {
    final raw = _playlistsBox.get(id);
    if (raw is! Map) {
      return const [];
    }
    final playlist = LibraryPlaylistRecord.fromMap(raw);
    return playlist.trackIds;
  }

  Future<void> _emitLiked() async {
    _likedController.add(await getLikedTracks());
  }

  Future<void> _emitPlaylists() async {
    _playlistsController.add(await getPlaylists());
  }

  Future<void> _migrateLegacyLikesIfNeeded() async {
    final keys = _likesBox.keys.toList();
    for (final key in keys) {
      final raw = _likesBox.get(key);
      if (raw is bool) {
        if (!raw) {
          await _likesBox.delete(key);
          continue;
        }
        // کامنت فارسی: داده قدیمی likes از bool به snapshot کامل Track مهاجرت می‌شود.
        final migrated = LikedTrackRecord(
          liked: true,
          updatedAt: DateTime.now(),
          track: Track(
            id: key.toString(),
            title: 'Unknown title',
            artist: 'Unknown artist',
          ),
        );
        await _likesBox.put(key, migrated.toMap());
      }
    }
  }

  Future<void> _migrateLegacyPlaylistsIfNeeded() async {
    final keys = _playlistsBox.keys.toList();
    if (keys.isEmpty) {
      await _playlistsBox.put(
        defaultPlaylistId,
        LibraryPlaylistRecord(
          id: defaultPlaylistId,
          name: defaultPlaylistName,
          trackIds: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ).toMap(),
      );
      return;
    }

    for (final key in keys) {
      final raw = _playlistsBox.get(key);
      if (raw is List) {
        final trackIds = raw.map((item) => item.toString()).toList();
        final migrated = LibraryPlaylistRecord(
          id: key.toString(),
          name: key.toString() == defaultPlaylistId
              ? defaultPlaylistName
              : key.toString(),
          trackIds: trackIds,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _playlistsBox.put(key, migrated.toMap());
      }
    }
  }
}
