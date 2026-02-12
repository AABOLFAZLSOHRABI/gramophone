import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/domain/models/playback_source.dart';

class PlayerState {
  const PlayerState({
    required this.currentTrack,
    required this.queue,
    required this.currentIndex,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.isLoading,
    required this.isDownloaded,
    required this.isLiked,
    required this.source,
    required this.errorMessage,
    required this.infoMessage,
  });

  const PlayerState.initial()
    : currentTrack = null,
      queue = const [],
      currentIndex = -1,
      isPlaying = false,
      position = Duration.zero,
      duration = Duration.zero,
      isLoading = false,
      isDownloaded = false,
      isLiked = false,
      source = PlaybackSource.none,
      errorMessage = null,
      infoMessage = null;

  final Track? currentTrack;
  final List<Track> queue;
  final int currentIndex;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isLoading;
  final bool isDownloaded;
  final bool isLiked;
  final PlaybackSource source;
  final String? errorMessage;
  final String? infoMessage;

  PlayerState copyWith({
    Track? currentTrack,
    List<Track>? queue,
    int? currentIndex,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLoading,
    bool? isDownloaded,
    bool? isLiked,
    PlaybackSource? source,
    String? errorMessage,
    String? infoMessage,
    bool clearError = false,
    bool clearInfo = false,
  }) {
    return PlayerState(
      currentTrack: currentTrack ?? this.currentTrack,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isLiked: isLiked ?? this.isLiked,
      source: source ?? this.source,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
    );
  }
}
