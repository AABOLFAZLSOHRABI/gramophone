import 'dart:io';

import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../domain/entities/track.dart';
import '../models/downloaded_track_record.dart';

class OfflineDownloadDataSource {
  static const offlineTracksBoxName = 'offline_tracks_box';

  Box<dynamic> get _box => Hive.box<dynamic>(offlineTracksBoxName);

  Future<void> saveDownloadedTrack(
    Track track, {
    required String audioFilePath,
    String? artworkFilePath,
  }) async {
    final record = DownloadedTrackRecord(
      trackId: track.id,
      title: track.title,
      artist: track.artist,
      artistHandle: track.artistHandle,
      imagePath: artworkFilePath ?? track.imageUrl,
      duration: track.duration,
      tags: track.tags,
      genre: track.genre,
      mood: track.mood,
      isDownloadable: track.isDownloadable,
      audioFilePath: audioFilePath,
      downloadedAt: DateTime.now(),
    );

    await _box.put(track.id, record.toMap());
  }

  Future<List<DownloadedTrackRecord>> getDownloadedTracks() async {
    final result = <DownloadedTrackRecord>[];
    final invalidKeys = <dynamic>[];

    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is! Map) {
        invalidKeys.add(key);
        continue;
      }

      final record = DownloadedTrackRecord.fromMap(raw);
      final audioFile = File(record.audioFilePath);
      if (!await audioFile.exists()) {
        invalidKeys.add(key);
        continue;
      }

      result.add(record);
    }

    if (invalidKeys.isNotEmpty) {
      await _box.deleteAll(invalidKeys);
    }

    return result;
  }

  Future<bool> isTrackDownloaded(String trackId) async {
    final raw = _box.get(trackId);
    if (raw is! Map) {
      return false;
    }

    final record = DownloadedTrackRecord.fromMap(raw);
    final exists = await File(record.audioFilePath).exists();
    if (!exists) {
      await _box.delete(trackId);
      return false;
    }

    return true;
  }

  Future<String?> getDownloadedAudioPath(String trackId) async {
    final raw = _box.get(trackId);
    if (raw is! Map) {
      return null;
    }

    final record = DownloadedTrackRecord.fromMap(raw);
    final audioFile = File(record.audioFilePath);
    if (!await audioFile.exists()) {
      await _box.delete(trackId);
      return null;
    }

    return record.audioFilePath;
  }

  Future<void> removeDownloadedTrack(String trackId) async {
    final raw = _box.get(trackId);
    if (raw is! Map) {
      return;
    }

    final record = DownloadedTrackRecord.fromMap(raw);
    final audioFile = File(record.audioFilePath);
    if (await audioFile.exists()) {
      await audioFile.delete();
    }

    final imagePath = record.imagePath;
    if (imagePath != null && imagePath.isNotEmpty) {
      final imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    }

    await _box.delete(trackId);
  }
}
