import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gramophone/core/network/dio_client.dart';
import 'package:gramophone/core/network/failure.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/data/dtos/artwork_dto.dart';
import 'package:gramophone/data/dtos/playlist_dto.dart';
import 'package:gramophone/data/dtos/track_dto.dart';
import 'package:gramophone/domain/entities/review_item.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/data/datasources/audius_remote_data_source.dart';
import 'package:gramophone/features/main/data/datasources/main_local_data_source.dart';
import 'package:gramophone/features/main/data/datasources/offline_download_data_source.dart';
import 'package:gramophone/features/main/data/main_repository_impl.dart';
import 'package:gramophone/features/main/data/models/downloaded_track_record.dart';

void main() {
  group('MainRepositoryImpl', () {
    late FakeAudiusRemoteDataSource remote;
    late FakeMainLocalDataSource local;
    late FakeOfflineDownloadDataSource offline;
    late FakeDioClient dioClient;
    late MainRepositoryImpl repository;
    final now = DateTime(2026, 2, 11);

    setUp(() {
      remote = FakeAudiusRemoteDataSource();
      local = FakeMainLocalDataSource();
      offline = FakeOfflineDownloadDataSource();
      dioClient = FakeDioClient();
      repository = MainRepositoryImpl(
        remote,
        local,
        offline,
        dioClient,
        clock: () => now,
      );
    });

    test('watchTrendingTracks emits cached then refreshed tracks', () async {
      local.cachedTracks = [_dto(id: '1', title: 'cached')];
      local.cacheTimestamp = now;
      remote.responseTracks = [_dto(id: '2', title: 'fresh')];

      final results = await repository.watchTrendingTracks().toList();

      expect(results.length, 2);
      expect(results[0], isA<ResultSuccess<List<Track>>>());
      expect(
        (results[0] as ResultSuccess<List<Track>>).data.first.title,
        'cached',
      );
      expect(results[1], isA<ResultSuccess<List<Track>>>());
      expect(
        (results[1] as ResultSuccess<List<Track>>).data.first.title,
        'fresh',
      );
    });

    test(
      'watchTrendingTracks emits failure when no cache and remote fails',
      () async {
        remote.error = DioException(
          requestOptions: RequestOptions(path: '/tracks/trending'),
          type: DioExceptionType.connectionError,
        );

        final results = await repository.watchTrendingTracks().toList();

        expect(results.length, 1);
        expect(results.first, isA<ResultFailure<List<Track>>>());
        final failure = (results.first as ResultFailure<List<Track>>).failure;
        expect(failure, isA<NetworkFailure>());
      },
    );

    test('refreshTrendingTracks returns success and writes cache', () async {
      remote.responseTracks = [_dto(id: '7', title: 'remote')];

      final result = await repository.refreshTrendingTracks();

      expect(result, isA<ResultSuccess<void>>());
      expect(local.cachedTracks.first.id, '7');
      expect(local.cacheTimestamp, now);
    });

    test('getTrendingTracksFromApi returns success from remote only', () async {
      local.cachedTracks = [_dto(id: '1', title: 'cached')];
      remote.responseTracks = [_dto(id: '8', title: 'api')];

      final result = await repository.getTrendingTracksFromApi();

      expect(result, isA<ResultSuccess<List<Track>>>());
      expect((result as ResultSuccess<List<Track>>).data.first.title, 'api');
      expect(local.cachedTracks.first.title, 'cached');
    });

    test(
      'getTrendingTracksFromApi returns mapped failure on dio error',
      () async {
        remote.error = DioException(
          requestOptions: RequestOptions(path: '/tracks/trending'),
          type: DioExceptionType.connectionError,
        );

        final result = await repository.getTrendingTracksFromApi();

        expect(result, isA<ResultFailure<List<Track>>>());
        expect(
          (result as ResultFailure<List<Track>>).failure,
          isA<NetworkFailure>(),
        );
      },
    );

    test(
      'downloadTrack returns success and skips when already downloaded',
      () async {
        offline.isDownloadedByTrackId['10'] = true;
        const track = Track(
          id: '10',
          title: 'a',
          artist: 'b',
          streamUrl: 'https://x',
        );

        final result = await repository.downloadTrack(track);

        expect(result, isA<ResultSuccess<void>>());
        expect(dioClient.downloadCalls, 0);
      },
    );

    test('getReviewItemsFromApi maps playlist dto to review item', () async {
      remote.responsePlaylists = const [
        PlaylistDto(
          id: 'pl-1',
          name: 'My Playlist',
          creatorName: 'DJ Test',
          description: 'Top tracks of the year',
          artwork480: 'https://img.test/480.jpg',
          tracks: [
            TrackDto(
              id: 't-1',
              title: 'Track One',
              artist: 'DJ Test',
              streamUrl: 'https://stream.test/1',
              artwork: ArtworkDto(x1000: 'https://img.test/track-1.jpg'),
            ),
          ],
        ),
      ];

      final result = await repository.getReviewItemsFromApi();

      expect(result, isA<ResultSuccess<List<ReviewItem>>>());
      final items = (result as ResultSuccess<List<ReviewItem>>).data;
      expect(items.first.id, 'pl-1');
      expect(items.first.title, 'My Playlist');
      expect(items.first.subtitle, 'Top tracks of the year');
      expect(items.first.imageUrl, 'https://img.test/track-1.jpg');
      expect(items.first.tracks, isNotEmpty);
      expect(items.first.tracks.first.streamUrl, isNotEmpty);
    });

    test('watchOfflineTracks emits downloaded tracks as success', () async {
      offline.records = [
        DownloadedTrackRecord(
          trackId: '5',
          title: 'offline',
          artist: 'artist',
          audioFilePath: '/tmp/5.mp3',
          downloadedAt: DateTime(2026, 2, 11),
        ),
      ];

      final results = await repository.watchOfflineTracks().toList();

      expect(results.length, 1);
      expect(results.first, isA<ResultSuccess<List<Track>>>());
      final tracks = (results.first as ResultSuccess<List<Track>>).data;
      expect(tracks.first.id, '5');
    });
  });
}

TrackDto _dto({required String id, required String title}) {
  return TrackDto(id: id, title: title, artist: 'artist', streamUrl: '');
}

class FakeAudiusRemoteDataSource extends AudiusRemoteDataSource {
  FakeAudiusRemoteDataSource() : super(DioClient());

  List<TrackDto> responseTracks = const [];
  List<PlaylistDto> responsePlaylists = const [];
  Object? error;

  @override
  Future<List<TrackDto>> getTrendingTracks({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  }) async {
    if (error != null) {
      throw error!;
    }
    return responseTracks;
  }

  @override
  Future<List<PlaylistDto>> getTrendingPlaylists({
    int offset = 0,
    int limit = 10,
    String time = 'week',
    String type = 'playlist',
  }) async {
    if (error != null) {
      throw error!;
    }
    return responsePlaylists;
  }
}

class FakeMainLocalDataSource extends MainLocalDataSource {
  List<TrackDto> cachedTracks = const [];
  DateTime? cacheTimestamp;

  @override
  Future<void> cacheTrendingTracks(
    List<TrackDto> tracks, {
    required DateTime fetchedAt,
  }) async {
    cachedTracks = tracks;
    cacheTimestamp = fetchedAt;
  }

  @override
  Future<List<TrackDto>> getCachedTrendingTracks() async => cachedTracks;

  @override
  Future<DateTime?> getTrendingCacheTimestamp() async => cacheTimestamp;
}

class FakeOfflineDownloadDataSource extends OfflineDownloadDataSource {
  List<DownloadedTrackRecord> records = const [];
  Map<String, bool> isDownloadedByTrackId = {};

  @override
  Future<List<DownloadedTrackRecord>> getDownloadedTracks() async => records;

  @override
  Future<bool> isTrackDownloaded(String trackId) async =>
      isDownloadedByTrackId[trackId] ?? false;
}

class FakeDioClient extends DioClient {
  int downloadCalls = 0;

  @override
  Future<Response<dynamic>> download(
    String url,
    String savePath, {
    Map<String, dynamic>? query,
  }) async {
    downloadCalls += 1;
    return Response<dynamic>(requestOptions: RequestOptions(path: url));
  }
}
