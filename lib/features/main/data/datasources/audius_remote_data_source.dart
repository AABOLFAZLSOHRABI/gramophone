import 'package:gramophone/features/main/models/track_model.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/endpoints.dart';

class AudiusRemoteDataSource {
  final DioClient _client;
  AudiusRemoteDataSource(this._client);

  // قبلاً: Future<List<dynamic>>
  // الان: Future<List<TrackModel>>
  Future<List<TrackModel>> getTrendingTracks({
    int limit = 20,
    String time = 'week',
  }) async {
    final res = await _client.get(
      Endpoints.trendingTracks,
      query: {'limit': limit, 'time': time},
    );

    final data = res.data;

    // Audius: { "data": [ {...}, {...} ] }
    if (data is Map && data['data'] is List) {
      final list = List<Map<String, dynamic>>.from(data['data']);
      return list.map(TrackModel.fromJson).toList();
    }

    return [];
  }
}
