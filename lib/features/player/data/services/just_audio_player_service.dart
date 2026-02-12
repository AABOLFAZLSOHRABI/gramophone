import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/domain/models/playback_source.dart';
import 'package:gramophone/features/player/domain/services/audio_player_service.dart';

class JustAudioPlayerService implements AudioPlayerService {
  JustAudioPlayerService(this._player);

  final AudioPlayer _player;

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Stream<bool> get playingStream => _player.playingStream.distinct();

  @override
  Stream<bool> get completedStream => _player.playerStateStream
      .map((state) => state.processingState == ProcessingState.completed)
      .distinct();

  @override
  Future<PlaybackSource> setSource(Track track, {String? localFilePath}) async {
    try {
      if (localFilePath != null && localFilePath.isNotEmpty) {
        await _player.setFilePath(localFilePath);
        await _player.seek(Duration.zero);
        return PlaybackSource.local;
      }

      final streamUrl = track.streamUrl;
      if (streamUrl == null || streamUrl.isEmpty) {
        throw StateError('Stream URL is empty for track ${track.id}.');
      }

      await _player.setUrl(streamUrl);
      await _player.seek(Duration.zero);
      return PlaybackSource.stream;
    } on MissingPluginException {
      throw const AudioBackendUnavailableException();
    } on PlatformException catch (error) {
      if (error.code.toLowerCase().contains('missing')) {
        throw const AudioBackendUnavailableException();
      }
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    try {
      await _player.play();
    } on MissingPluginException {
      throw const AudioBackendUnavailableException();
    } on PlatformException catch (error) {
      if (error.code.toLowerCase().contains('missing')) {
        throw const AudioBackendUnavailableException();
      }
      rethrow;
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
    } on MissingPluginException {
      throw const AudioBackendUnavailableException();
    } on PlatformException catch (error) {
      if (error.code.toLowerCase().contains('missing')) {
        throw const AudioBackendUnavailableException();
      }
      rethrow;
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } on MissingPluginException {
      throw const AudioBackendUnavailableException();
    } on PlatformException catch (error) {
      if (error.code.toLowerCase().contains('missing')) {
        throw const AudioBackendUnavailableException();
      }
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _player.dispose();
    } on MissingPluginException {
      // Ignore disposal when backend isn't available on this build.
    } on PlatformException catch (error) {
      if (!error.code.toLowerCase().contains('missing')) {
        rethrow;
      }
    }
  }
}
