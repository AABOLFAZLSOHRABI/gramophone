import 'package:gramophone/domain/entities/track.dart';

sealed class PlayerEvent {
  const PlayerEvent();
}

final class PlayTrackRequested extends PlayerEvent {
  const PlayTrackRequested({
    required this.queue,
    required this.index,
    this.autoPlay = true,
  });

  final List<Track> queue;
  final int index;
  final bool autoPlay;
}

final class TogglePlayPausePressed extends PlayerEvent {
  const TogglePlayPausePressed();
}

final class PlayPressed extends PlayerEvent {
  const PlayPressed();
}

final class PausePressed extends PlayerEvent {
  const PausePressed();
}

final class NextPressed extends PlayerEvent {
  const NextPressed();
}

final class PreviousPressed extends PlayerEvent {
  const PreviousPressed();
}

final class SeekChanged extends PlayerEvent {
  const SeekChanged(this.position);

  final Duration position;
}

final class ToggleLikePressed extends PlayerEvent {
  const ToggleLikePressed(this.trackId);

  final String trackId;
}

final class AddToPlaylistPressed extends PlayerEvent {
  const AddToPlaylistPressed(this.trackId, {this.playlistId});

  final String trackId;
  final String? playlistId;
}

final class DownloadPressed extends PlayerEvent {
  const DownloadPressed(this.track);

  final Track track;
}

final class MessageConsumed extends PlayerEvent {
  const MessageConsumed();
}

final class PositionUpdatedInternal extends PlayerEvent {
  const PositionUpdatedInternal(this.position);

  final Duration position;
}

final class DurationUpdatedInternal extends PlayerEvent {
  const DurationUpdatedInternal(this.duration);

  final Duration duration;
}

final class PlayingUpdatedInternal extends PlayerEvent {
  const PlayingUpdatedInternal(this.isPlaying);

  final bool isPlaying;
}

final class CompletedChangedInternal extends PlayerEvent {
  const CompletedChangedInternal(this.completed);

  final bool completed;
}
