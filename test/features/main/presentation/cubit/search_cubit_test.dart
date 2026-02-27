import 'package:flutter_test/flutter_test.dart';
import 'package:gramophone/core/network/failure.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/domain/entities/review_item.dart';
import 'package:gramophone/domain/entities/search_playlist.dart';
import 'package:gramophone/domain/entities/search_user.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/features/main/presentation/cubit/search_cubit.dart';
import 'package:gramophone/features/main/presentation/cubit/search_state.dart';

void main() {
  group('SearchCubit', () {
    late FakeMainRepository repository;
    late SearchCubit cubit;

    setUp(() {
      repository = FakeMainRepository();
      cubit = SearchCubit(repository);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('query shorter than 2 chars resets state without API call', () async {
      await cubit.loadTrendingByGenre(genre: 'Pop');
      cubit.onQueryChanged('a');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(repository.searchTracksCalls, 0);
      expect(repository.searchUsersCalls, 0);
      expect(repository.searchPlaylistsCalls, 0);
      expect(cubit.state.query, 'a');
      expect(cubit.state.isGenreMode, isFalse);
      expect(cubit.state.activeGenre, isNull);
      expect(cubit.state.tracks, isEmpty);
      expect(cubit.state.users, isEmpty);
      expect(cubit.state.playlists, isEmpty);
    });

    test('valid query loads tracks, users and playlists', () async {
      repository.tracksResult = ResultSuccess([
        const Track(id: 't1', title: 'Track 1', artist: 'Artist'),
      ]);
      repository.usersResult = ResultSuccess([
        const SearchUser(
          id: 'u1',
          name: 'User 1',
          handle: 'user1',
          imageUrl: null,
          isVerified: false,
        ),
      ]);
      repository.playlistsResult = ResultSuccess([
        const SearchPlaylist(
          id: 'p1',
          name: 'Playlist 1',
          creatorName: 'Creator',
          imageUrl: null,
          trackCount: 1,
        ),
      ]);

      final states = <SearchState>[];
      final sub = cubit.stream.listen(states.add);
      cubit.onQueryChanged('rock');

      await Future<void>.delayed(const Duration(milliseconds: 500));
      expect(states.any((state) => state.isLoadingInitial), isTrue);
      expect(cubit.state.isLoadingInitial, isFalse);
      expect(cubit.state.tracks.length, 1);
      expect(cubit.state.users.length, 1);
      expect(cubit.state.playlists.length, 1);
      await sub.cancel();
    });

    test(
      'partial failure keeps successful sections and sets section error',
      () async {
        repository.tracksResult = ResultSuccess([
          const Track(id: 't1', title: 'Track 1', artist: 'Artist'),
        ]);
        repository.usersResult = ResultFailure(ServerFailure('users failed'));
        repository.playlistsResult = const ResultSuccess([]);

        cubit.onQueryChanged('jazz');
        await Future<void>.delayed(const Duration(milliseconds: 500));

        expect(cubit.state.tracks, isNotEmpty);
        expect(cubit.state.users, isEmpty);
        expect(cubit.state.usersErrorMessage, 'users failed');
        expect(cubit.state.errorMessage, isNull);
      },
    );

    test('loadMoreTracks appends and updates offset', () async {
      repository.tracksResult = ResultSuccess(
        List.generate(
          20,
          (index) =>
              Track(id: 't$index', title: 'Track $index', artist: 'Artist'),
        ),
      );
      repository.usersResult = const ResultSuccess([]);
      repository.playlistsResult = const ResultSuccess([]);

      cubit.onQueryChanged('house');
      await Future<void>.delayed(const Duration(milliseconds: 500));

      repository.nextTracksResult = ResultSuccess([
        const Track(id: 't20', title: 'Track 20', artist: 'Artist'),
      ]);
      await cubit.loadMoreTracks();

      expect(cubit.state.tracks.length, 21);
      expect(cubit.state.offsetTracks, 21);
    });

    test(
      'loadTrendingByGenre loads tracks only and enables genre mode',
      () async {
        repository.trendingResult = ResultSuccess([
          const Track(id: 't1', title: 'Track 1', artist: 'Artist'),
        ]);

        await cubit.loadTrendingByGenre(genre: 'Pop');

        expect(cubit.state.isGenreMode, isTrue);
        expect(cubit.state.activeGenre, 'Pop');
        expect(cubit.state.tracks.length, 1);
        expect(cubit.state.users, isEmpty);
        expect(cubit.state.playlists, isEmpty);
        expect(repository.trendingCalls, 1);
      },
    );

    test('genre pagination appends tracks from trending endpoint', () async {
      repository.trendingResult = ResultSuccess(
        List.generate(
          20,
          (index) =>
              Track(id: 'g$index', title: 'Genre $index', artist: 'Artist'),
        ),
      );

      await cubit.loadTrendingByGenre(genre: 'Indie');
      repository.nextTrendingResult = ResultSuccess([
        const Track(id: 'g20', title: 'Genre 20', artist: 'Artist'),
      ]);

      await cubit.loadMoreTracks();
      expect(cubit.state.tracks.length, 21);
      expect(cubit.state.offsetTracks, 21);
      expect(repository.trendingCalls, 2);
    });

    test('loadUndergroundTrending loads track list', () async {
      repository.undergroundResult = ResultSuccess([
        const Track(id: 'u1', title: 'Underground 1', artist: 'Artist'),
      ]);

      await cubit.loadUndergroundTrending();

      expect(cubit.state.currentMode, SearchPresetMode.tracksUnderground);
      expect(cubit.state.tracks.length, 1);
      expect(cubit.state.users, isEmpty);
      expect(cubit.state.playlists, isEmpty);
      expect(repository.undergroundCalls, 1);
    });

    test('loadFeelingLucky loads tracks and disables pagination', () async {
      repository.feelingLuckyResult = ResultSuccess([
        const Track(id: 'l1', title: 'Lucky', artist: 'Artist'),
      ]);

      await cubit.loadFeelingLucky();

      expect(cubit.state.currentMode, SearchPresetMode.feelingLucky);
      expect(cubit.state.tracks.length, 1);
      expect(cubit.state.hasMoreTracks, isFalse);
      expect(repository.feelingLuckyCalls, 1);
    });

    test('loadPlaylistSearchPreset loads playlists only', () async {
      repository.playlistsResult = ResultSuccess([
        const SearchPlaylist(
          id: 'p1',
          name: 'Podcasts',
          creatorName: 'Creator',
          imageUrl: null,
          trackCount: 8,
        ),
      ]);

      await cubit.loadPlaylistSearchPreset(query: 'Podcasts');

      expect(cubit.state.currentMode, SearchPresetMode.playlistSearch);
      expect(cubit.state.playlists.length, 1);
      expect(cubit.state.tracks, isEmpty);
      expect(cubit.state.users, isEmpty);
    });

    test(
      'loadMoreUsers failure keeps current data and sets pagination error',
      () async {
        repository.tracksResult = const ResultSuccess([]);
        repository.usersResult = ResultSuccess(
          List.generate(
            20,
            (index) => SearchUser(
              id: 'u$index',
              name: 'User $index',
              handle: 'user$index',
              imageUrl: null,
              isVerified: false,
            ),
          ),
        );
        repository.playlistsResult = const ResultSuccess([]);

        cubit.onQueryChanged('pop');
        await Future<void>.delayed(const Duration(milliseconds: 500));
        final initialUsers = List<SearchUser>.from(cubit.state.users);

        repository.nextUsersResult = ResultFailure(
          NetworkFailure('page failed'),
        );
        await cubit.loadMoreUsers();

        expect(cubit.state.users.length, initialUsers.length);
        expect(cubit.state.paginationErrorMessage, 'page failed');
      },
    );
  });
}

class FakeMainRepository implements MainRepository {
  Result<List<Track>> tracksResult = const ResultSuccess([]);
  Result<List<SearchUser>> usersResult = const ResultSuccess([]);
  Result<List<SearchPlaylist>> playlistsResult = const ResultSuccess([]);
  Result<List<Track>>? nextTracksResult;
  Result<List<Track>> trendingResult = const ResultSuccess([]);
  Result<List<Track>>? nextTrendingResult;
  Result<List<Track>> undergroundResult = const ResultSuccess([]);
  Result<List<Track>> feelingLuckyResult = const ResultSuccess([]);
  Result<List<SearchUser>>? nextUsersResult;
  Result<List<SearchPlaylist>>? nextPlaylistsResult;
  int searchTracksCalls = 0;
  int searchUsersCalls = 0;
  int searchPlaylistsCalls = 0;
  int trendingCalls = 0;
  int undergroundCalls = 0;
  int feelingLuckyCalls = 0;

  @override
  Future<Result<List<Track>>> searchTracks({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    searchTracksCalls += 1;
    if (offset == 0) {
      return tracksResult;
    }
    return nextTracksResult ?? const ResultSuccess([]);
  }

  @override
  Future<Result<List<SearchUser>>> searchUsers({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    searchUsersCalls += 1;
    if (offset == 0) {
      return usersResult;
    }
    return nextUsersResult ?? const ResultSuccess([]);
  }

  @override
  Future<Result<List<SearchPlaylist>>> searchPlaylists({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    searchPlaylistsCalls += 1;
    if (offset == 0) {
      return playlistsResult;
    }
    return nextPlaylistsResult ?? const ResultSuccess([]);
  }

  @override
  Future<Result<List<Track>>> getTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  }) async {
    trendingCalls += 1;
    if (offset == 0) {
      return trendingResult;
    }
    return nextTrendingResult ?? const ResultSuccess([]);
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
  Future<Result<List<Track>>> getUndergroundTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
  }) async {
    undergroundCalls += 1;
    return undergroundResult;
  }

  @override
  Future<Result<List<Track>>> getFeelingLuckyTracksFromApi({
    int limit = 20,
  }) async {
    feelingLuckyCalls += 1;
    return feelingLuckyResult;
  }

  @override
  Stream<Result<List<Track>>> watchOfflineTracks() async* {
    yield const ResultSuccess([]);
  }

  @override
  Future<Result<void>> downloadTrack(Track track) async {
    return const ResultSuccess(null);
  }

  @override
  Future<Result<bool>> isTrackDownloaded(String trackId) async {
    return const ResultSuccess(false);
  }

  @override
  Future<Result<void>> removeOfflineTrack(String trackId) async {
    return const ResultSuccess(null);
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
}
