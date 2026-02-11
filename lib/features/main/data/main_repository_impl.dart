import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/endpoints.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/network/failure.dart';
import '../../../core/result/result.dart';
import '../../../data/mappers/playlist_mapper.dart';
import '../../../data/dtos/track_dto.dart';
import '../../../data/mappers/track_mapper.dart';
import '../../../domain/entities/review_item.dart';
import '../../../domain/entities/track.dart';
import '../domain/repositories/main_repository.dart';
import 'datasources/audius_remote_data_source.dart';
import 'datasources/main_local_data_source.dart';
import 'datasources/offline_download_data_source.dart';

class MainRepositoryImpl implements MainRepository {
  MainRepositoryImpl(
    this._remote,
    this._local,
    this._offline,
    this._dioClient, {
    Duration? cacheTtl,
    DateTime Function()? clock,
  }) : _cacheTtl = cacheTtl ?? const Duration(days: 30),
       _clock = clock ?? DateTime.now;

  final AudiusRemoteDataSource _remote;
  final MainLocalDataSource _local;
  final OfflineDownloadDataSource _offline;
  final DioClient _dioClient;
  final Duration _cacheTtl;
  final DateTime Function() _clock;

  @override
  Future<Result<List<Track>>> getTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  }) async {
    try {
      final remoteTracks = await _remote.getTrendingTracks(
        offset: offset,
        limit: limit,
        time: time,
        genre: genre,
      );
      return ResultSuccess(_toTrackEntities(remoteTracks));
    } catch (error) {
      return ResultFailure(_mapFailure(error));
    }
  }

  @override
  Stream<Result<List<Track>>> watchTrendingTracks({
    int limit = 20,
    String time = 'week',
  }) async* {
    bool emittedCache = false;
    final cached = await _local.getCachedTrendingTracks();

    if (cached.isNotEmpty) {
      emittedCache = true;
      yield ResultSuccess(_toTrackEntities(cached));
    }

    final refreshResult = await _refreshTrendingTracksData(
      limit: limit,
      time: time,
    );

    switch (refreshResult) {
      case ResultSuccess<List<Track>>():
        yield refreshResult;
      case ResultFailure<List<Track>>():
        if (!emittedCache) {
          yield refreshResult;
        } else {
          log(
            'watchTrendingTracks refresh failed while cache exists: '
            '${refreshResult.failure.message}',
          );
        }
    }
  }

  @override
  Future<Result<void>> refreshTrendingTracks({
    int limit = 20,
    String time = 'week',
  }) async {
    final result = await _refreshTrendingTracksData(limit: limit, time: time);

    switch (result) {
      case ResultSuccess<List<Track>>():
        return const ResultSuccess(null);
      case ResultFailure<List<Track>>():
        return ResultFailure(result.failure);
    }
  }

  @override
  Future<Result<void>> downloadTrack(Track track) async {
    if (track.streamUrl == null || track.streamUrl!.isEmpty) {
      return ResultFailure(
        UnknownFailure('Track stream url is empty for track ${track.id}.'),
      );
    }

    try {
      final isAlreadyDownloaded = await _offline.isTrackDownloaded(track.id);
      if (isAlreadyDownloaded) {
        return const ResultSuccess(null);
      }

      final docsDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory(
        '${docsDir.path}${Platform.pathSeparator}offline_audio',
      );
      final artworkDir = Directory(
        '${docsDir.path}${Platform.pathSeparator}offline_artwork',
      );

      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }
      if (!await artworkDir.exists()) {
        await artworkDir.create(recursive: true);
      }

      final audioPath =
          '${audioDir.path}${Platform.pathSeparator}${track.id}.mp3';
      String? artworkPath;

      try {
        await _dioClient.download(track.streamUrl!, audioPath);

        final imageUrl = track.imageUrl;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          artworkPath =
              '${artworkDir.path}${Platform.pathSeparator}${track.id}.jpg';
          await _dioClient.download(imageUrl, artworkPath);
        }

        await _offline.saveDownloadedTrack(
          track,
          audioFilePath: audioPath,
          artworkFilePath: artworkPath,
        );

        return const ResultSuccess(null);
      } catch (error) {
        await _rollbackDownloadedFiles(audioPath, artworkPath);
        return ResultFailure(_mapFailure(error));
      }
    } catch (error) {
      return ResultFailure(_mapFailure(error));
    }
  }

  @override
  Future<Result<List<ReviewItem>>> getReviewItemsFromApi({
    int offset = 0,
    int limit = 10,
    String time = 'week',
  }) async {
    try {
      final playlists = await _remote.getTrendingPlaylists(
        offset: offset,
        limit: limit,
        time: time,
      );
      final items = playlists.map((playlist) => playlist.toReviewItem()).toList();
      return ResultSuccess(items);
    } catch (error) {
      return ResultFailure(_mapFailure(error));
    }
  }

  @override
  Stream<Result<List<Track>>> watchOfflineTracks() async* {
    try {
      final records = await _offline.getDownloadedTracks();
      final tracks = records.map((record) => record.toEntity()).toList();
      yield ResultSuccess(tracks);
    } catch (error) {
      yield ResultFailure(_mapFailure(error));
    }
  }

  @override
  Future<Result<bool>> isTrackDownloaded(String trackId) async {
    try {
      final isDownloaded = await _offline.isTrackDownloaded(trackId);
      return ResultSuccess(isDownloaded);
    } catch (error) {
      return ResultFailure(_mapFailure(error));
    }
  }

  @override
  Future<Result<void>> removeOfflineTrack(String trackId) async {
    try {
      await _offline.removeDownloadedTrack(trackId);
      return const ResultSuccess(null);
    } catch (error) {
      return ResultFailure(_mapFailure(error));
    }
  }

  Future<Result<List<Track>>> _refreshTrendingTracksData({
    required int limit,
    required String time,
  }) async {
    final cached = await _local.getCachedTrendingTracks();
    final fetchedAt = await _local.getTrendingCacheTimestamp();
    final cacheIsFresh = cached.isNotEmpty &&
        fetchedAt != null &&
        _clock().difference(fetchedAt) <= _cacheTtl;

    if (cacheIsFresh) {
      try {
        final remoteTracks = await _remote.getTrendingTracks(
          limit: limit,
          time: time,
        );
        await _local.cacheTrendingTracks(remoteTracks, fetchedAt: _clock());
        return ResultSuccess(_toTrackEntities(remoteTracks));
      } catch (error) {
        return ResultFailure(_mapFailure(error));
      }
    }

    try {
      final remoteTracks = await _remote.getTrendingTracks(
        limit: limit,
        time: time,
      );
      await _local.cacheTrendingTracks(remoteTracks, fetchedAt: _clock());
      return ResultSuccess(_toTrackEntities(remoteTracks));
    } catch (error) {
      if (cached.isNotEmpty) {
        return ResultSuccess(_toTrackEntities(cached));
      }
      return ResultFailure(_mapFailure(error));
    }
  }

  List<Track> _toTrackEntities(List<TrackDto> dtos) {
    return dtos
        .map((dto) => dto.toEntity(apiBaseUrl: Endpoints.audiusBaseUrl))
        .toList();
  }

  Failure _mapFailure(Object error) {
    if (error is DioException) {
      return mapDioErrorToFailure(error);
    }
    if (error is Failure) {
      return error;
    }
    return UnknownFailure(error.toString());
  }

  Future<void> _rollbackDownloadedFiles(
    String audioPath,
    String? artworkPath,
  ) async {
    final audioFile = File(audioPath);
    if (await audioFile.exists()) {
      await audioFile.delete();
    }

    if (artworkPath == null) {
      return;
    }
    final artworkFile = File(artworkPath);
    if (await artworkFile.exists()) {
      await artworkFile.delete();
    }
  }
}
