import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/domain/models/playback_source.dart';
import 'package:gramophone/features/player/domain/models/player_playlist.dart';
import 'package:gramophone/features/player/domain/repositories/player_repository.dart';
import 'package:gramophone/features/player/domain/services/audio_player_service.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';
import 'package:gramophone/features/player/presentation/bloc/player_state.dart';

void main() {
  late FakeAudioPlayerService audioService;
  late FakePlayerRepository repository;
  late PlayerBloc bloc;

  setUp(() {
    audioService = FakeAudioPlayerService();
    repository = FakePlayerRepository();
    bloc = PlayerBloc(audioService, repository);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('EnsureAutoplayRequested starts playback only when idle', () async {
    const track = Track(id: 't1', title: 'Song', artist: 'Artist');

    bloc.add(const EnsureAutoplayRequested(track));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(audioService.playCalls, greaterThan(0));
    expect(bloc.state.status, PlaybackStatus.playing);
  });

  test('ToggleLikePressed toggles like state via snapshot track', () async {
    const track = Track(id: 't2', title: 'Liked', artist: 'Artist');

    bloc.add(const EnsureAutoplayRequested(track));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.isLiked, isFalse);

    bloc.add(const ToggleLikePressed(track));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.isLiked, isTrue);
  });

  test('DownloadPressed sets downloaded state', () async {
    const track = Track(id: 't3', title: 'Download', artist: 'Artist');

    bloc.add(const EnsureAutoplayRequested(track));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    bloc.add(const DownloadPressed(track));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(bloc.state.isDownloaded, isTrue);
  });

  test('CreatePlaylistPressed creates and updates playlists', () async {
    bloc.add(const CreatePlaylistPressed('Road'));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(bloc.state.playlists.any((item) => item.name == 'Road'), isTrue);
  });
}

class FakeAudioPlayerService implements AudioPlayerService {
  int playCalls = 0;
  final _position = StreamController<Duration>.broadcast();
  final _duration = StreamController<Duration?>.broadcast();
  final _playing = StreamController<bool>.broadcast();
  final _completed = StreamController<bool>.broadcast();

  @override
  Stream<bool> get completedStream => _completed.stream;

  @override
  Stream<Duration?> get durationStream => _duration.stream;

  @override
  Stream<bool> get playingStream => _playing.stream;

  @override
  Stream<Duration> get positionStream => _position.stream;

  @override
  Future<void> dispose() async {
    await _position.close();
    await _duration.close();
    await _playing.close();
    await _completed.close();
  }

  @override
  Future<void> pause() async {
    _playing.add(false);
  }

  @override
  Future<void> play() async {
    playCalls += 1;
    _playing.add(true);
  }

  @override
  Future<void> seek(Duration position) async {
    _position.add(position);
  }

  @override
  Future<PlaybackSource> setSource(Track track, {String? localFilePath}) async {
    _duration.add(const Duration(minutes: 3));
    return PlaybackSource.stream;
  }

  @override
  Future<void> stop() async {
    _playing.add(false);
  }
}

class FakePlayerRepository implements PlayerRepository {
  final Set<String> _liked = {};
  final List<Track> _downloaded = [];
  final List<PlayerPlaylist> _playlists = [];
  final _likedCtrl = StreamController<List<Track>>.broadcast();
  final _downloadedCtrl = StreamController<List<Track>>.broadcast();
  final _playlistsCtrl = StreamController<List<PlayerPlaylist>>.broadcast();

  @override
  Future<void> addToPlaylist(String trackId, {String? playlistId}) async {}

  @override
  Future<String> createPlaylist(String name) async {
    final id = 'p-${_playlists.length + 1}';
    _playlists.add(
      PlayerPlaylist(
        id: id,
        name: name,
        trackIds: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    _playlistsCtrl.add(List<PlayerPlaylist>.from(_playlists));
    return id;
  }

  @override
  Future<void> downloadTrack(Track track) async {
    _downloaded.add(track);
    _downloadedCtrl.add(List<Track>.from(_downloaded));
  }

  @override
  Future<List<Track>> getLikedTracks() async {
    return _liked.map((id) => Track(id: id, title: id, artist: 'A')).toList();
  }

  @override
  Future<String?> getLocalAudioPath(String trackId) async => null;

  @override
  Future<List<Track>> getOfflineTracks() async => _downloaded;

  @override
  Future<List<PlayerPlaylist>> getPlaylists() async =>
      List<PlayerPlaylist>.from(_playlists);

  @override
  Future<bool> isLiked(String trackId) async => _liked.contains(trackId);

  @override
  Future<bool> isTrackDownloaded(String trackId) async =>
      _downloaded.any((item) => item.id == trackId);

  @override
  Future<void> toggleLike(String trackId) async {
    if (_liked.contains(trackId)) {
      _liked.remove(trackId);
    } else {
      _liked.add(trackId);
    }
    _likedCtrl.add(await getLikedTracks());
  }

  @override
  Future<void> toggleLikeTrack(Track track) => toggleLike(track.id);

  @override
  Stream<List<Track>> watchDownloadedTracks() async* {
    yield List<Track>.from(_downloaded);
    yield* _downloadedCtrl.stream;
  }

  @override
  Stream<List<Track>> watchLikedTracks() async* {
    yield await getLikedTracks();
    yield* _likedCtrl.stream;
  }

  @override
  Stream<List<PlayerPlaylist>> watchPlaylists() async* {
    yield List<PlayerPlaylist>.from(_playlists);
    yield* _playlistsCtrl.stream;
  }
}
