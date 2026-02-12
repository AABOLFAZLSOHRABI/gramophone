import 'package:gramophone/domain/entities/track.dart';

class PlayerState {
  const PlayerState({
    required this.currentTrack,
    required this.isPlaying,
    required this.queue,
    required this.currentIndex,
  });

  const PlayerState.initial()
    : currentTrack = null,
      isPlaying = false,
      queue = const [],
      currentIndex = -1;

  final Track? currentTrack;
  final bool isPlaying;
  final List<Track> queue;
  final int currentIndex;

  PlayerState copyWith({
    Track? currentTrack,
    bool? isPlaying,
    List<Track>? queue,
    int? currentIndex,
    bool clearTrack = false,
  }) {
    return PlayerState(
      currentTrack: clearTrack ? null : (currentTrack ?? this.currentTrack),
      isPlaying: isPlaying ?? this.isPlaying,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
