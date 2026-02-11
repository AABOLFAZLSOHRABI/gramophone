import '../../../../core/result/result.dart';
import '../../../../domain/entities/review_item.dart';
import '../../../../domain/entities/track.dart';

abstract class MainRepository {
  Future<Result<List<Track>>> getTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  });

  Stream<Result<List<Track>>> watchTrendingTracks({
    int limit = 20,
    String time = 'week',
  });
  Future<Result<void>> refreshTrendingTracks({
    int limit = 20,
    String time = 'week',
  });
  Future<Result<void>> downloadTrack(Track track);
  Future<Result<List<ReviewItem>>> getReviewItemsFromApi({
    int offset = 0,
    int limit = 10,
    String time = 'week',
  });
  Stream<Result<List<Track>>> watchOfflineTracks();
  Future<Result<bool>> isTrackDownloaded(String trackId);
  Future<Result<void>> removeOfflineTrack(String trackId);
}
