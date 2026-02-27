import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/domain/entities/review_item.dart';
import 'package:gramophone/domain/entities/search_playlist.dart';
import 'package:gramophone/domain/entities/search_user.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/features/main/pages/search_input_page.dart';
import 'package:gramophone/features/main/presentation/cubit/search_cubit.dart';
import 'package:gramophone/features/main/presentation/cubit/search_state.dart';

void main() {
  testWidgets('shows min characters hint initially', (tester) async {
    final repository = FakeMainRepository();
    final cubit = SearchCubit(repository);

    await tester.pumpWidget(_wrap(SearchInputPage(cubit: cubit)));
    expect(find.text('Enter at least 2 characters to search.'), findsOneWidget);
  });

  testWidgets('renders search results after typing query', (tester) async {
    final repository = FakeMainRepository()
      ..tracksResult = ResultSuccess([
        const Track(id: 't1', title: 'Track 1', artist: 'Artist 1'),
      ])
      ..usersResult = ResultSuccess([
        const SearchUser(
          id: 'u1',
          name: 'User 1',
          handle: 'user1',
          imageUrl: null,
          isVerified: true,
        ),
      ])
      ..playlistsResult = ResultSuccess([
        const SearchPlaylist(
          id: 'p1',
          name: 'Playlist 1',
          creatorName: 'Creator',
          imageUrl: null,
          trackCount: 3,
        ),
      ]);
    final cubit = SearchCubit(repository);

    await tester.pumpWidget(_wrap(SearchInputPage(cubit: cubit)));
    await tester.enterText(find.byType(TextField), 'rock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Track 1'), findsOneWidget);
    expect(find.text('User 1'), findsOneWidget);
    expect(find.text('Playlist 1'), findsOneWidget);
  });

  testWidgets('loads trending tracks when initialGenre is provided', (
    tester,
  ) async {
    final repository = FakeMainRepository()
      ..trendingResult = ResultSuccess([
        const Track(id: 't-pop', title: 'Pop Track', artist: 'Pop Artist'),
      ]);
    final cubit = SearchCubit(repository);

    await tester.pumpWidget(
      _wrap(SearchInputPage(cubit: cubit, initialGenre: 'Pop')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pop Track'), findsOneWidget);
    expect(repository.trendingCalls, 1);
    expect(cubit.state.isGenreMode, isTrue);
  });

  testWidgets('loads playlists when initialAction is playlistSearch', (
    tester,
  ) async {
    final repository = FakeMainRepository()
      ..playlistsResult = ResultSuccess([
        const SearchPlaylist(
          id: 'pl1',
          name: 'Podcasts Daily',
          creatorName: 'Creator',
          imageUrl: null,
          trackCount: 12,
        ),
      ]);
    final cubit = SearchCubit(repository);

    await tester.pumpWidget(
      _wrap(
        SearchInputPage(
          cubit: cubit,
          initialAction: {
            'mode': 'playlistSearch',
            'value': 'Podcasts',
            'title': 'Podcasts',
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Podcasts Daily'), findsOneWidget);
    expect(cubit.state.currentMode, SearchPresetMode.playlistSearch);
  });

  testWidgets('loads tracks when initialAction is tracksUnderground', (
    tester,
  ) async {
    final repository = FakeMainRepository()
      ..undergroundResult = ResultSuccess([
        const Track(id: 'u1', title: 'Under Track', artist: 'Artist'),
      ]);
    final cubit = SearchCubit(repository);

    await tester.pumpWidget(
      _wrap(
        SearchInputPage(
          cubit: cubit,
          initialAction: {'mode': 'tracksUnderground', 'title': 'Underground'},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Under Track'), findsOneWidget);
    expect(cubit.state.currentMode, SearchPresetMode.tracksUnderground);
  });
}

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, __) => MaterialApp(home: child),
  );
}

class FakeMainRepository implements MainRepository {
  Result<List<Track>> tracksResult = const ResultSuccess([]);
  Result<List<Track>> trendingResult = const ResultSuccess([]);
  Result<List<Track>> undergroundResult = const ResultSuccess([]);
  Result<List<Track>> feelingLuckyResult = const ResultSuccess([]);
  Result<List<SearchUser>> usersResult = const ResultSuccess([]);
  Result<List<SearchPlaylist>> playlistsResult = const ResultSuccess([]);
  int trendingCalls = 0;

  @override
  Future<Result<List<Track>>> searchTracks({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    return tracksResult;
  }

  @override
  Future<Result<List<SearchUser>>> searchUsers({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    return usersResult;
  }

  @override
  Future<Result<List<SearchPlaylist>>> searchPlaylists({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    return playlistsResult;
  }

  @override
  Future<Result<List<Track>>> getTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  }) async {
    trendingCalls += 1;
    return trendingResult;
  }

  @override
  Future<Result<List<Track>>> getUndergroundTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
  }) async {
    return undergroundResult;
  }

  @override
  Future<Result<List<Track>>> getFeelingLuckyTracksFromApi({
    int limit = 20,
  }) async {
    return feelingLuckyResult;
  }

  @override
  Stream<Result<List<Track>>> watchTrendingTracks({
    int limit = 20,
    String time = 'week',
  }) async* {
    yield const ResultSuccess([]);
  }

  @override
  Future<Result<void>> refreshTrendingTracks({
    int limit = 20,
    String time = 'week',
  }) async {
    return const ResultSuccess(null);
  }

  @override
  Future<Result<void>> downloadTrack(Track track) async {
    return const ResultSuccess(null);
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
  Stream<Result<List<Track>>> watchOfflineTracks() async* {
    yield const ResultSuccess([]);
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
