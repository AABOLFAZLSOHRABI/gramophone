import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../../../data/dtos/track_dto.dart';

class MainLocalDataSource {
  static const trendingCacheBoxName = 'trending_cache_box';

  static const _trendingTracksKey = 'trending_tracks';
  static const _trendingFetchedAtKey = 'trending_fetched_at';

  Box<dynamic> get _box => Hive.box<dynamic>(trendingCacheBoxName);

  Future<void> cacheTrendingTracks(
    List<TrackDto> tracks, {
    required DateTime fetchedAt,
  }) async {
    final serialized = tracks.map((track) => track.toJson()).toList();
    await _box.put(_trendingTracksKey, serialized);
    await _box.put(_trendingFetchedAtKey, fetchedAt.millisecondsSinceEpoch);
  }

  Future<List<TrackDto>> getCachedTrendingTracks() async {
    final raw = _box.get(_trendingTracksKey);
    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(TrackDto.fromJson)
        .toList();
  }

  Future<DateTime?> getTrendingCacheTimestamp() async {
    final raw = _box.get(_trendingFetchedAtKey);
    if (raw is! int) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(raw);
  }

  Future<void> clearExpiredTrendingCache({required Duration ttl}) async {
    final fetchedAt = await getTrendingCacheTimestamp();
    if (fetchedAt == null) {
      return;
    }

    if (DateTime.now().difference(fetchedAt) > ttl) {
      await _box.delete(_trendingTracksKey);
      await _box.delete(_trendingFetchedAtKey);
    }
  }
}
