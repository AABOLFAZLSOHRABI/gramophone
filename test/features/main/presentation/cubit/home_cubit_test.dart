import 'package:flutter_test/flutter_test.dart';
import 'package:gramophone/core/network/failure.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/domain/entities/review_item.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/features/main/presentation/cubit/home_cubit.dart';
import 'package:gramophone/features/main/presentation/cubit/home_state.dart';

void main() {
  group('HomeCubit', () {
    late FakeMainRepository repository;
    late HomeCubit cubit;

    setUp(() {
      repository = FakeMainRepository();
      cubit = HomeCubit(repository);
    });

    tearDown(() {
      cubit.close();
    });

    test('emits [Loading, Loaded] when both API calls succeed', () async {
      repository.allTimeResult = ResultSuccess([_track(id: '1', title: 'A')]);
      repository.weekResult = ResultSuccess([_track(id: '2', title: 'B')]);

      final states = <HomeState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.loadHome();
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<HomeLoading>());
      expect(states[1], isA<HomeLoaded>());
      final loaded = states[1] as HomeLoaded;
      expect(loaded.recentlyPlayed.first.id, '1');
      expect(loaded.editorsPicks.first.id, '2');

      await sub.cancel();
    });

    test('emits [Loading, Error] when both API calls fail', () async {
      repository.allTimeResult = ResultFailure(NetworkFailure('No internet'));
      repository.weekResult = ResultFailure(ServerFailure('Server down'));

      final states = <HomeState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.loadHome();
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<HomeLoading>());
      expect(states[1], isA<HomeError>());

      await sub.cancel();
    });

    test('supports partial success', () async {
      repository.allTimeResult = ResultSuccess([_track(id: '1', title: 'A')]);
      repository.weekResult = ResultFailure(ServerFailure('Editors failed'));

      final states = <HomeState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.loadHome();
      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      final loaded = states[1] as HomeLoaded;
      expect(loaded.recentlyPlayed.length, 1);
      expect(loaded.editorsPicks, isEmpty);
      expect(loaded.editorsError, 'Editors failed');

      await sub.cancel();
    });
  });
}

Track _track({required String id, required String title}) {
  return Track(id: id, title: title, artist: 'artist');
}

class FakeMainRepository implements MainRepository {
  Result<List<Track>> allTimeResult = const ResultSuccess([]);
  Result<List<Track>> weekResult = const ResultSuccess([]);
  Result<List<ReviewItem>> reviewResult = const ResultSuccess([]);

  @override
  Future<Result<List<Track>>> getTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  }) async {
    if (time == 'allTime') {
      return allTimeResult;
    }
    return weekResult;
  }

  @override
  Future<Result<List<ReviewItem>>> getReviewItemsFromApi({
    int offset = 0,
    int limit = 10,
    String time = 'week',
  }) async {
    return reviewResult;
  }

  @override
  Future<Result<void>> downloadTrack(Track track) async {
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
  Future<Result<bool>> isTrackDownloaded(String trackId) async {
    return const ResultSuccess(false);
  }

  @override
  Future<Result<void>> removeOfflineTrack(String trackId) async {
    return const ResultSuccess(null);
  }

  @override
  Stream<Result<List<Track>>> watchOfflineTracks() async* {
    yield const ResultSuccess([]);
  }

  @override
  Stream<Result<List<Track>>> watchTrendingTracks({
    int limit = 20,
    String time = 'week',
  }) async* {
    yield const ResultSuccess([]);
  }
}
