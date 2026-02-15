import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/data/datasources/player_local_data_source.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() {
  late Directory tempDir;
  late PlayerLocalDataSource dataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('gram-player-local-test');
    Hive.init(tempDir.path);
    await Hive.openBox<dynamic>(PlayerLocalDataSource.likesBoxName);
    await Hive.openBox<dynamic>(PlayerLocalDataSource.playlistsBoxName);
    dataSource = PlayerLocalDataSource();
  });

  tearDown(() async {
    await Hive.box<dynamic>(PlayerLocalDataSource.likesBoxName).clear();
    await Hive.box<dynamic>(PlayerLocalDataSource.playlistsBoxName).clear();
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('migrates bool likes to map schema and returns liked tracks', () async {
    final box = Hive.box<dynamic>(PlayerLocalDataSource.likesBoxName);
    await box.put('t1', true);

    final liked = await dataSource.watchLikedTracks().first;

    expect(liked, isNotEmpty);
    expect(liked.first.id, 't1');
    expect(box.get('t1'), isA<Map>());
  });

  test('toggleLikeTrack emits updated liked list', () async {
    const track = Track(id: 't2', title: 'Song', artist: 'Artist');
    final next = dataSource.watchLikedTracks().skip(1).first;
    await dataSource.toggleLikeTrack(track);
    final liked = await next;

    expect(liked.any((item) => item.id == 't2'), isTrue);
  });

  test('create playlist and add track updates playlist contents', () async {
    final id = await dataSource.createPlaylist('Road');
    await dataSource.addToPlaylist('t3', playlistId: id);
    final playlists = await dataSource.getPlaylists();
    final playlist = playlists.firstWhere((item) => item.id == id);

    expect(playlist.name, 'Road');
    expect(playlist.trackIds, contains('t3'));
  });
}
