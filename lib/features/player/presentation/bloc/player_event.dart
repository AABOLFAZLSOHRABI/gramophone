import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/domain/models/player_playlist.dart';

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
  const ToggleLikePressed(this.track);

  final Track track;
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

final class EnsureAutoplayRequested extends PlayerEvent {
  const EnsureAutoplayRequested(this.track);

  final Track track;
}

final class ToggleShufflePressed extends PlayerEvent {
  const ToggleShufflePressed();
}

final class ToggleRepeatPressed extends PlayerEvent {
  const ToggleRepeatPressed();
}

final class LoadPlaylistsRequested extends PlayerEvent {
  const LoadPlaylistsRequested();
}

final class CreatePlaylistPressed extends PlayerEvent {
  const CreatePlaylistPressed(this.name);

  final String name;
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

final class LikedTracksUpdatedInternal extends PlayerEvent {
  const LikedTracksUpdatedInternal(this.tracks);

  final List<Track> tracks;
}

final class DownloadedTracksUpdatedInternal extends PlayerEvent {
  const DownloadedTracksUpdatedInternal(this.tracks);

  final List<Track> tracks;
}

final class PlaylistsUpdatedInternal extends PlayerEvent {
  const PlaylistsUpdatedInternal(this.playlists);

  final List<PlayerPlaylist> playlists;
}
