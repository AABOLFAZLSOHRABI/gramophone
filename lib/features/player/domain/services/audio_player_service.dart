import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/domain/models/playback_source.dart';

class AudioBackendUnavailableException implements Exception {
  const AudioBackendUnavailableException();
}

enum AudioPlaybackPhase { setSource, play, pause, seek, stop }

class AudioPlaybackException implements Exception {
  const AudioPlaybackException({
    required this.phase,
    required this.trackId,
    this.code,
    this.message,
    this.sourceHost,
  });

  final AudioPlaybackPhase phase;
  final String trackId;
  final String? code;
  final String? message;
  final String? sourceHost;

  @override
  String toString() {
    return 'AudioPlaybackException('
        'phase: $phase, '
        'trackId: $trackId, '
        'code: $code, '
        'sourceHost: $sourceHost, '
        'message: $message'
        ')';
  }
}

abstract class AudioPlayerService {
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
  Stream<bool> get playingStream;
  Stream<bool> get completedStream;

  Future<PlaybackSource> setSource(Track track, {String? localFilePath});
  Future<void> stop();
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> dispose();
}
