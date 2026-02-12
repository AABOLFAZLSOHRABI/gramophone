import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/features/player/domain/repositories/player_repository.dart';
import 'package:gramophone/features/player/domain/services/audio_player_service.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';
import 'package:gramophone/features/player/presentation/bloc/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc(this._audioService, this._repository)
    : super(const PlayerState.initial()) {
    on<LoadQueueAndTrack>(_onLoadQueueAndTrack);
    on<TogglePlayPausePressed>(_onTogglePlayPausePressed);
    on<PlayPressed>(_onPlayPressed);
    on<PausePressed>(_onPausePressed);
    on<NextPressed>(_onNextPressed);
    on<PreviousPressed>(_onPreviousPressed);
    on<SeekChanged>(_onSeekChanged);
    on<ToggleLikePressed>(_onToggleLikePressed);
    on<AddToPlaylistPressed>(_onAddToPlaylistPressed);
    on<DownloadPressed>(_onDownloadPressed);
    on<MessageConsumed>(_onMessageConsumed);
    on<PositionUpdatedInternal>(_onPositionUpdated);
    on<DurationUpdatedInternal>(_onDurationUpdated);
    on<PlayingUpdatedInternal>(_onPlayingUpdated);
    on<CompletedChangedInternal>(_onCompletedChanged);

    _positionSub = _audioService.positionStream.listen((position) {
      add(PositionUpdatedInternal(position));
    });
    _durationSub = _audioService.durationStream.listen((duration) {
      if (duration != null) {
        add(DurationUpdatedInternal(duration));
      }
    });
    _playingSub = _audioService.playingStream.listen((isPlaying) {
      add(PlayingUpdatedInternal(isPlaying));
    });
    _completedSub = _audioService.completedStream.listen((completed) {
      add(CompletedChangedInternal(completed));
    });
  }

  final AudioPlayerService _audioService;
  final PlayerRepository _repository;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<bool>? _completedSub;

  Future<void> _onLoadQueueAndTrack(
    LoadQueueAndTrack event,
    Emitter<PlayerState> emit,
  ) async {
    if (event.queue.isEmpty) {
      emit(state.copyWith(errorMessage: AppStrings.queueIsEmpty));
      return;
    }

    final index = event.startIndex.clamp(0, event.queue.length - 1);
    final track = event.queue[index];

    emit(
      state.copyWith(
        queue: event.queue,
        currentIndex: index,
        currentTrack: track,
        isLoading: true,
        position: Duration.zero,
        duration: Duration.zero,
        clearError: true,
        clearInfo: true,
      ),
    );

    try {
      final localPath = await _repository.getLocalAudioPath(track.id);
      final source = await _audioService.setSource(
        track,
        localFilePath: localPath,
      );
      await _audioService.play();

      final downloaded = await _repository.isTrackDownloaded(track.id);
      final liked = await _repository.isLiked(track.id);

      emit(
        state.copyWith(
          source: source,
          isDownloaded: downloaded,
          isLiked: liked,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _toUiMessage(error)));
    }
  }

  Future<void> _onTogglePlayPausePressed(
    TogglePlayPausePressed event,
    Emitter<PlayerState> emit,
  ) async {
    try {
      if (state.isPlaying) {
        await _audioService.pause();
      } else {
        await _audioService.play();
      }
    } catch (error) {
      emit(state.copyWith(errorMessage: _toUiMessage(error)));
    }
  }

  Future<void> _onPlayPressed(
    PlayPressed event,
    Emitter<PlayerState> emit,
  ) async {
    try {
      await _audioService.play();
    } catch (error) {
      emit(state.copyWith(errorMessage: _toUiMessage(error)));
    }
  }

  Future<void> _onPausePressed(
    PausePressed event,
    Emitter<PlayerState> emit,
  ) async {
    try {
      await _audioService.pause();
    } catch (error) {
      emit(state.copyWith(errorMessage: _toUiMessage(error)));
    }
  }

  Future<void> _onNextPressed(
    NextPressed event,
    Emitter<PlayerState> emit,
  ) async {
    final queue = state.queue;
    if (queue.isEmpty) return;

    final nextIndex = state.currentIndex + 1;
    if (nextIndex < 0 || nextIndex >= queue.length) return;

    add(LoadQueueAndTrack(queue: queue, startIndex: nextIndex));
  }

  Future<void> _onPreviousPressed(
    PreviousPressed event,
    Emitter<PlayerState> emit,
  ) async {
    final queue = state.queue;
    if (queue.isEmpty) return;

    final prevIndex = state.currentIndex - 1;
    if (prevIndex < 0 || prevIndex >= queue.length) return;

    add(LoadQueueAndTrack(queue: queue, startIndex: prevIndex));
  }

  Future<void> _onSeekChanged(
    SeekChanged event,
    Emitter<PlayerState> emit,
  ) async {
    try {
      await _audioService.seek(event.position);
    } catch (error) {
      emit(state.copyWith(errorMessage: _toUiMessage(error)));
    }
  }

  Future<void> _onToggleLikePressed(
    ToggleLikePressed event,
    Emitter<PlayerState> emit,
  ) async {
    await _repository.toggleLike(event.trackId);
    final liked = await _repository.isLiked(event.trackId);
    emit(state.copyWith(isLiked: liked));
  }

  Future<void> _onAddToPlaylistPressed(
    AddToPlaylistPressed event,
    Emitter<PlayerState> emit,
  ) async {
    await _repository.addToPlaylist(
      event.trackId,
      playlistId: event.playlistId,
    );
    emit(
      state.copyWith(infoMessage: AppStrings.addedToPlaylist, clearError: true),
    );
  }

  Future<void> _onDownloadPressed(
    DownloadPressed event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.isDownloaded) {
      emit(
        state.copyWith(
          infoMessage: AppStrings.alreadyDownloaded,
          clearError: true,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true, clearInfo: true));
    try {
      await _repository.downloadTrack(event.track);
      emit(
        state.copyWith(
          isDownloaded: true,
          isLoading: false,
          infoMessage: AppStrings.downloadedSuccessfully,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _toUiMessage(error)));
    }
  }

  String _toUiMessage(Object error) {
    if (error is AudioBackendUnavailableException) {
      return AppStrings.audioBackendUnavailable;
    }
    return error.toString();
  }

  void _onMessageConsumed(MessageConsumed event, Emitter<PlayerState> emit) {
    emit(state.copyWith(clearError: true, clearInfo: true));
  }

  void _onPositionUpdated(
    PositionUpdatedInternal event,
    Emitter<PlayerState> emit,
  ) {
    emit(state.copyWith(position: event.position));
  }

  void _onDurationUpdated(
    DurationUpdatedInternal event,
    Emitter<PlayerState> emit,
  ) {
    emit(state.copyWith(duration: event.duration));
  }

  void _onPlayingUpdated(
    PlayingUpdatedInternal event,
    Emitter<PlayerState> emit,
  ) {
    emit(state.copyWith(isPlaying: event.isPlaying));
  }

  void _onCompletedChanged(
    CompletedChangedInternal event,
    Emitter<PlayerState> emit,
  ) {
    if (event.completed) {
      add(const NextPressed());
    }
  }

  @override
  Future<void> close() async {
    await _positionSub?.cancel();
    await _durationSub?.cancel();
    await _playingSub?.cancel();
    await _completedSub?.cancel();
    await _audioService.dispose();
    return super.close();
  }
}
