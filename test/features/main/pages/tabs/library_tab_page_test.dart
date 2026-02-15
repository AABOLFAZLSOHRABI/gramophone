import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/features/library/domain/entities/library_playlist.dart';
import 'package:gramophone/features/library/domain/entities/library_source_type.dart';
import 'package:gramophone/features/library/domain/entities/library_track.dart';
import 'package:gramophone/features/library/domain/repositories/library_repository.dart';
import 'package:gramophone/features/library/presentation/cubit/library_cubit.dart';
import 'package:gramophone/features/main/pages/tabs/library_tab_page.dart';

void main() {
  late FakeLibraryRepository repository;

  setUp(() async {
    await sl.reset();
    repository = FakeLibraryRepository();
    sl.registerLazySingleton<LibraryRepository>(() => repository);
    sl.registerLazySingleton<LibraryCubit>(
      () => LibraryCubit(sl<LibraryRepository>()),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('renders library shell and source switcher', (tester) async {
    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.pump();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Local'), findsOneWidget);
    expect(find.text('Gram'), findsOneWidget);
  });

  testWidgets('shows tracks and quick access cards', (tester) async {
    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.pumpAndSettle();

    expect(find.text('All Songs'), findsWidgets);
    expect(find.text('Albums'), findsWidgets);
    expect(find.text('Downloaded'), findsWidgets);
    expect(find.text('Liked'), findsWidgets);
  });

  testWidgets('switches source to gram', (tester) async {
    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gram'));
    await tester.pumpAndSettle();

    final cubit = sl<LibraryCubit>();
    expect(cubit.state.source, LibrarySourceType.gram);
  });

  testWidgets('filters list by search query', (tester) async {
    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Local');
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Local One'), findsOneWidget);
  });
}

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(430, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(home: child),
  );
}

class FakeLibraryRepository implements LibraryRepository {
  final List<LibraryTrack> _local = const [
    LibraryTrack(id: 'l1', title: 'Local One', artist: 'Artist A'),
    LibraryTrack(id: 'l2', title: 'Local Two', artist: 'Artist B'),
  ];
  final List<LibraryTrack> _gram = const [
    LibraryTrack(id: 'g1', title: 'Gram One', artist: 'Artist G'),
  ];
  final List<LibraryTrack> _downloaded = const [];
  final List<LibraryTrack> _liked = const [];
  final List<LibraryPlaylist> _playlists = [
    LibraryPlaylist(
      id: 'p1',
      name: 'My Playlist',
      trackIds: ['g1'],
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 2),
    ),
  ];

  FakeLibraryRepository();

  @override
  Future<void> addToPlaylist(String trackId, String playlistId) async {}

  @override
  Future<String> createPlaylist(String name) async => 'new';

  @override
  Future<void> deletePlaylist(String id) async {}

  @override
  Future<void> refreshGramData() async {}

  @override
  Future<void> renamePlaylist(String id, String name) async {}

  @override
  Future<void> scanLocalLibrary({bool pickFoldersOnDesktop = false}) async {}

  @override
  Future<List<LibraryTrack>> search({
    required LibrarySourceType source,
    required String query,
  }) async {
    return const [];
  }

  @override
  Future<void> toggleLike(String trackId) async {}

  @override
  Stream<List<LibraryTrack>> watchGramAllTracks() async* {
    yield _gram;
  }

  @override
  Stream<List<LibraryTrack>> watchGramDownloadedTracks() async* {
    yield _downloaded;
  }

  @override
  Stream<List<LibraryTrack>> watchGramLikedTracks() async* {
    yield _liked;
  }

  @override
  Stream<List<LibraryPlaylist>> watchGramPlaylists() async* {
    yield _playlists;
  }

  @override
  Stream<List<LibraryTrack>> watchLocalTracks() async* {
    yield _local;
  }

  @override
  Future<List<LibraryTrack>> getTracksForPlaylist(String playlistId) async =>
      const [];
}
