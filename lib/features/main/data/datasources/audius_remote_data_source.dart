import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../data/dtos/playlist_dto.dart';
import '../../../../data/dtos/track_dto.dart';
import '../models/search_playlist_model.dart';
import '../models/search_user_model.dart';

class AudiusRemoteDataSource {
  AudiusRemoteDataSource(this._client);

  final DioClient _client;

  Future<List<TrackDto>> getTrendingTracks({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  }) async {
    final query = <String, dynamic>{
      'offset': offset,
      'limit': limit,
      'time': time,
    };
    if (genre != null && genre.isNotEmpty) {
      query['genre'] = genre;
    }

    final res = await _client.get(Endpoints.trendingTracks, query: query);

    final data = res.data;
    if (data is Map && data['data'] is List) {
      final list = List<Map<String, dynamic>>.from(data['data']);
      return list.map(_toTrackDto).toList();
    }

    return [];
  }

  Future<List<PlaylistDto>> getTrendingPlaylists({
    int offset = 0,
    int limit = 10,
    String time = 'week',
    String type = 'playlist',
  }) async {
    final res = await _client.get(
      Endpoints.trendingPlaylists,
      query: {'offset': offset, 'limit': limit, 'time': time, 'type': type},
    );

    final data = res.data;
    if (data is Map && data['data'] is List) {
      final list = List<Map<String, dynamic>>.from(data['data']);
      return list.map(PlaylistDto.fromJson).toList();
    }

    return [];
  }

  Future<List<TrackDto>> getUndergroundTrendingTracks({
    int offset = 0,
    int limit = 20,
  }) async {
    final res = await _client.get(
      Endpoints.trendingUndergroundTracks,
      query: {'offset': offset, 'limit': limit},
    );

    final data = res.data;
    if (data is Map && data['data'] is List) {
      final list = List<Map<String, dynamic>>.from(data['data']);
      return list.map(_toTrackDto).toList();
    }

    return [];
  }

  Future<List<TrackDto>> getFeelingLuckyTracks({int limit = 20}) async {
    final res = await _client.get(
      Endpoints.feelingLuckyTracks,
      query: {'limit': limit},
    );

    final data = res.data;
    if (data is Map && data['data'] is List) {
      final list = List<Map<String, dynamic>>.from(data['data']);
      return list.map(_toTrackDto).toList();
    }

    return [];
  }

  Future<List<TrackDto>> searchTracks({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    final res = await _client.get(
      Endpoints.searchTracks,
      query: {
        'query': query,
        'offset': offset,
        'limit': limit,
        'sort_method': sortMethod,
      },
    );

    final data = res.data;
    if (data is Map && data['data'] is List) {
      final list = List<Map<String, dynamic>>.from(data['data']);
      return list.map(_toTrackDto).toList();
    }

    return [];
  }

  Future<List<SearchUserModel>> searchUsers({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    final res = await _client.get(
      Endpoints.searchUsers,
      query: {
        'query': query,
        'offset': offset,
        'limit': limit,
        'sort_method': sortMethod,
      },
    );

    final data = res.data;
    if (data is Map && data['data'] is List) {
      final list = List<Map<String, dynamic>>.from(data['data']);
      return list.map(SearchUserModel.fromJson).toList();
    }

    return [];
  }

  Future<List<SearchPlaylistModel>> searchPlaylists({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  }) async {
    final res = await _client.get(
      Endpoints.searchPlaylists,
      query: {
        'query': query,
        'offset': offset,
        'limit': limit,
        'sort_method': sortMethod,
      },
    );

    final data = res.data;
    if (data is Map && data['data'] is List) {
      final list = List<Map<String, dynamic>>.from(data['data']);
      return list.map(SearchPlaylistModel.fromJson).toList();
    }

    return [];
  }

  TrackDto _toTrackDto(Map<String, dynamic> json) {
    final user = (json['user'] as Map?)?.cast<String, dynamic>() ?? {};

    return TrackDto.fromJson({
      'id': '${json['id']}',
      'title': json['title'] ?? '',
      'artist': user['name'] ?? '',
      'artistHandle': user['handle'] ?? '',
      'artwork': json['artwork'],
      'duration': json['duration'] ?? 0,
      'streamUrl': '',
      'tags': json['tags'] ?? '',
      'genre': json['genre'] ?? '',
      'mood': json['mood'] ?? '',
      'isDownloadable': json['is_downloadable'] ?? false,
    });
  }
}
