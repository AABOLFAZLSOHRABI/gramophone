import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/presentation/cubit/player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(const PlayerState.initial());

  void setCurrentTrack(Track track, {List<Track> queue = const []}) {
    final normalizedQueue = queue.isEmpty
        ? <Track>[track]
        : List<Track>.from(queue);
    final index = normalizedQueue.indexWhere((item) => item.id == track.id);
    final safeIndex = index >= 0 ? index : 0;

    emit(
      state.copyWith(
        currentTrack: track,
        isPlaying: true,
        queue: normalizedQueue,
        currentIndex: safeIndex,
      ),
    );
  }

  void togglePlayPause() {
    emit(state.copyWith(isPlaying: !state.isPlaying));
  }

  void play() {
    if (!state.isPlaying) {
      emit(state.copyWith(isPlaying: true));
    }
  }

  void pause() {
    if (state.isPlaying) {
      emit(state.copyWith(isPlaying: false));
    }
  }

  void nextTrack() {
    final queue = state.queue;
    if (queue.isEmpty) return;

    final nextIndex = state.currentIndex + 1;
    if (nextIndex < 0 || nextIndex >= queue.length) return;

    emit(
      state.copyWith(
        currentTrack: queue[nextIndex],
        currentIndex: nextIndex,
        isPlaying: true,
      ),
    );
  }
}
