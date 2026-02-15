import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/library_track.dart';

class LocalMediaDataSource {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<LibraryTrack>> scanMobileTracks() async {
    final hasPermission = await _ensureMobilePermission();
    if (!hasPermission) {
      throw StateError('Media permission denied.');
    }

    final songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return songs.map(_mapSongModel).toList();
  }

  Future<List<LibraryTrack>> scanDesktopTracks(List<String> folders) async {
    final tracks = <LibraryTrack>[];
    final supported = <String>{
      '.mp3',
      '.m4a',
      '.aac',
      '.wav',
      '.ogg',
      '.flac',
      '.opus',
    };

    for (final folder in folders) {
      final directory = Directory(folder);
      if (!await directory.exists()) {
        continue;
      }
      await for (final entity in directory.list(recursive: true)) {
        if (entity is! File) {
          continue;
        }
        final ext = _extension(entity.path).toLowerCase();
        if (!supported.contains(ext)) {
          continue;
        }
        tracks.add(await _mapDesktopFile(entity));
      }
    }
    return tracks;
  }

  Future<List<String>> pickDesktopFolders({
    required List<String> existingFolders,
  }) async {
    final selected = await FilePicker.platform.getDirectoryPath();
    if (selected == null || selected.trim().isEmpty) {
      return existingFolders;
    }
    final result = {...existingFolders, selected}.toList();
    return result;
  }

  Future<bool> _ensureMobilePermission() async {
    if (kIsWeb) {
      return false;
    }
    if (Platform.isAndroid) {
      final audio = await Permission.audio.request();
      if (audio.isGranted) {
        return true;
      }
      final storage = await Permission.storage.request();
      return storage.isGranted;
    }
    if (Platform.isIOS) {
      final media = await Permission.mediaLibrary.request();
      return media.isGranted;
    }
    return false;
  }

  LibraryTrack _mapSongModel(SongModel song) {
    final title = song.title.trim().isEmpty ? 'Unknown title' : song.title;
    final artist = (song.artist ?? '').trim().isEmpty
        ? 'Unknown artist'
        : song.artist!;
    final album = (song.album ?? '').trim().isEmpty ? null : song.album;
    final path = song.data.trim().isEmpty ? null : song.data;
    return LibraryTrack(
      id: 'local-${song.id}',
      title: title,
      artist: artist,
      album: album,
      duration: song.duration == null ? null : (song.duration! / 1000).round(),
      localPath: path,
      dateAdded: song.dateAdded == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(song.dateAdded!),
    );
  }

  Future<LibraryTrack> _mapDesktopFile(File file) async {
    String? title;
    String? artist;
    String? album;
    int? duration;

    try {
      final metadata = await MetadataRetriever.fromFile(file);
      title = metadata.trackName?.trim();
      artist = metadata.trackArtistNames?.join(', ').trim();
      album = metadata.albumName?.trim();
      duration = metadata.trackDuration;
    } catch (_) {
      // Ignore and use filename fallback.
    }

    final fallbackTitle = _basenameWithoutExtension(file.path);
    return LibraryTrack(
      id: 'local-${file.path.hashCode}',
      title: (title == null || title.isEmpty) ? fallbackTitle : title,
      artist: (artist == null || artist.isEmpty) ? 'Unknown artist' : artist,
      album: (album == null || album.isEmpty) ? null : album,
      duration: duration == null ? null : (duration / 1000).round(),
      localPath: file.path,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(
        (await file.lastModified()).millisecondsSinceEpoch,
      ),
    );
  }

  String _basenameWithoutExtension(String path) {
    final normalized = path.replaceAll('\\', '/');
    final last = normalized.split('/').last;
    final index = last.lastIndexOf('.');
    if (index <= 0) {
      return last;
    }
    return last.substring(0, index);
  }

  String _extension(String path) {
    final normalized = path.replaceAll('\\', '/');
    final last = normalized.split('/').last;
    final index = last.lastIndexOf('.');
    if (index < 0) {
      return '';
    }
    return last.substring(index);
  }
}
