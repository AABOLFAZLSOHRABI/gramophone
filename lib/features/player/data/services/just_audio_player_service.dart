import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/domain/models/playback_source.dart';
import 'package:gramophone/features/player/domain/services/audio_player_service.dart';

class JustAudioPlayerService implements AudioPlayerService {
  JustAudioPlayerService(this._player);

  final AudioPlayer _player;
  String _lastTrackId = 'unknown';
  String? _lastSourceHost;

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
    _lastTrackId = track.id;
    try {
      if (localFilePath != null && localFilePath.isNotEmpty) {
        _lastSourceHost = 'local-file';
        developer.log(
          'setSource phase local path=$localFilePath trackId=${track.id}',
          name: 'AudioService',
        );
        await _player.setFilePath(localFilePath);
        await _player.seek(Duration.zero);
        _logPlayerState(phase: AudioPlaybackPhase.setSource);
        return PlaybackSource.local;
      }

      final streamUrl = track.streamUrl;
      if (streamUrl == null || streamUrl.isEmpty) {
        throw AudioPlaybackException(
          phase: AudioPlaybackPhase.setSource,
          trackId: track.id,
          code: 'empty_stream_url',
          message: 'Track stream url is empty.',
        );
      }

      final parsed = Uri.tryParse(streamUrl);
      final isValidScheme =
          parsed != null &&
          (parsed.scheme == 'http' ||
              parsed.scheme == 'https' ||
              parsed.scheme == 'file');
      if (!isValidScheme) {
        throw AudioPlaybackException(
          phase: AudioPlaybackPhase.setSource,
          trackId: track.id,
          code: 'invalid_stream_url_scheme',
          sourceHost: parsed?.host,
          message: 'Stream url scheme is invalid.',
        );
      }
      _lastSourceHost = parsed.host;

      developer.log(
        'setSource phase stream host=${_lastSourceHost ?? 'n/a'} trackId=${track.id}',
        name: 'AudioService',
      );
      await _player.setUrl(streamUrl);
      await _player.seek(Duration.zero);
      _logPlayerState(phase: AudioPlaybackPhase.setSource);
      return PlaybackSource.stream;
    } on AudioPlaybackException {
      rethrow;
    } catch (error) {
      throw _mapError(
        error,
        phase: AudioPlaybackPhase.setSource,
        trackId: track.id,
      );
    }
  }

  @override
  Future<void> stop() async {
    try {
      developer.log('stop phase trackId=$_lastTrackId', name: 'AudioService');
      await _player.stop();
      _logPlayerState(phase: AudioPlaybackPhase.stop);
    } catch (error) {
      throw _mapError(
        error,
        phase: AudioPlaybackPhase.stop,
        trackId: _lastTrackId,
      );
    }
  }

  @override
  Future<void> play() async {
    try {
      developer.log(
        'play phase trackId=$_lastTrackId host=${_lastSourceHost ?? 'n/a'}',
        name: 'AudioService',
      );
      await _player.play();
      _logPlayerState(phase: AudioPlaybackPhase.play);
    } catch (error) {
      throw _mapError(
        error,
        phase: AudioPlaybackPhase.play,
        trackId: _lastTrackId,
      );
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
      _logPlayerState(phase: AudioPlaybackPhase.pause);
    } catch (error) {
      throw _mapError(
        error,
        phase: AudioPlaybackPhase.pause,
        trackId: _lastTrackId,
      );
    }
  }

  @override
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
      _logPlayerState(phase: AudioPlaybackPhase.seek);
    } catch (error) {
      throw _mapError(
        error,
        phase: AudioPlaybackPhase.seek,
        trackId: _lastTrackId,
      );
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

  Exception _mapError(
    Object error, {
    required AudioPlaybackPhase phase,
    required String trackId,
  }) {
    if (error is MissingPluginException) {
      return const AudioBackendUnavailableException();
    }

    if (error is PlatformException) {
      final code = error.code.toLowerCase();
      if (code.contains('missing')) {
        return const AudioBackendUnavailableException();
      }
      return AudioPlaybackException(
        phase: phase,
        trackId: trackId,
        code: error.code,
        message: error.message ?? error.details?.toString(),
        sourceHost: _lastSourceHost,
      );
    }

    if (error is PlayerException) {
      return AudioPlaybackException(
        phase: phase,
        trackId: trackId,
        code: error.code.toString(),
        message: error.message,
        sourceHost: _lastSourceHost,
      );
    }

    if (error is PlayerInterruptedException) {
      return AudioPlaybackException(
        phase: phase,
        trackId: trackId,
        code: 'interrupted',
        message: error.message,
        sourceHost: _lastSourceHost,
      );
    }

    return AudioPlaybackException(
      phase: phase,
      trackId: trackId,
      code: 'unknown',
      message: error.toString(),
      sourceHost: _lastSourceHost,
    );
  }

  void _logPlayerState({required AudioPlaybackPhase phase}) {
    developer.log(
      'phase=$phase '
      'playing=${_player.playing} '
      'processing=${_player.processingState} '
      'duration=${_player.duration?.inSeconds}',
      name: 'AudioService',
    );
  }
}
