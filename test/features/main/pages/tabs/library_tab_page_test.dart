import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/network/failure.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/domain/entities/review_item.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/features/main/pages/tabs/library_tab_page.dart';

void main() {
  late FakeMainRepository repository;

  setUp(() async {
    await sl.reset();
    repository = FakeMainRepository();
    sl.registerLazySingleton<MainRepository>(() => repository);
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('renders library header, quick access and horizontal sections', (
    tester,
  ) async {
    repository.offlineStream = Stream<Result<List<Track>>>.value(
      const ResultSuccess([]),
    );

    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.library), findsOneWidget);
    expect(find.text(AppStrings.libraryQuickAccess), findsOneWidget);
    expect(find.text(AppStrings.libraryAlbums), findsOneWidget);
    expect(find.text(AppStrings.libraryLikedSongs), findsOneWidget);
    expect(find.text(AppStrings.libraryRecentlyAdded), findsOneWidget);
  });

  testWidgets('shows loading state for downloaded section before first data', (
    tester,
  ) async {
    final controller = StreamController<Result<List<Track>>>();
    repository.offlineStream = controller.stream;

    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.scrollUntilVisible(
      find.byType(CircularProgressIndicator),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await controller.close();
  });

  testWidgets('shows empty downloaded state when stream result is empty', (
    tester,
  ) async {
    repository.offlineStream = Stream<Result<List<Track>>>.value(
      const ResultSuccess([]),
    );

    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(AppStrings.libraryDownloadsEmptyHint),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text(AppStrings.libraryDownloadsEmptyHint), findsOneWidget);
  });

  testWidgets('shows downloaded tracks list when stream has data', (
    tester,
  ) async {
    repository.offlineStream = Stream<Result<List<Track>>>.value(
      const ResultSuccess([
        Track(id: '1', title: 'Offline Track', artist: 'Artist'),
      ]),
    );

    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Offline Track'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Offline Track'), findsOneWidget);
    expect(find.text('Artist'), findsOneWidget);
  });

  testWidgets('shows failure message when stream returns failure', (
    tester,
  ) async {
    repository.offlineStream = Stream<Result<List<Track>>>.value(
      ResultFailure(ServerFailure('download failed')),
    );

    await tester.pumpWidget(_wrap(const LibraryTabPage()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('download failed'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('download failed'), findsOneWidget);
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

class FakeMainRepository implements MainRepository {
  Stream<Result<List<Track>>> offlineStream = Stream<Result<List<Track>>>.value(
    const ResultSuccess([]),
  );

  @override
  Stream<Result<List<Track>>> watchOfflineTracks() => offlineStream;

  @override
  Future<Result<void>> downloadTrack(Track track) async {
    return const ResultSuccess(null);
  }

  @override
  Future<Result<List<Track>>> getTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  }) async {
    return const ResultSuccess([]);
  }

  @override
  Future<Result<void>> refreshTrendingTracks({
    int limit = 20,
    String time = 'week',
  }) async {
    return const ResultSuccess(null);
  }

  @override
  Stream<Result<List<Track>>> watchTrendingTracks({
    int limit = 20,
    String time = 'week',
  }) async* {
    yield const ResultSuccess([]);
  }

  @override
  Future<Result<List<ReviewItem>>> getReviewItemsFromApi({
    int offset = 0,
    int limit = 10,
    String time = 'week',
  }) async {
    return const ResultSuccess([]);
  }

  @override
  Future<Result<bool>> isTrackDownloaded(String trackId) async {
    return const ResultSuccess(false);
  }

  @override
  Future<Result<void>> removeOfflineTrack(String trackId) async {
    return const ResultSuccess(null);
  }
}
