import '../../../../core/result/result.dart';
import '../../../../domain/entities/search_playlist.dart';
import '../../../../domain/entities/search_user.dart';
import '../../../../domain/entities/review_item.dart';
import '../../../../domain/entities/track.dart';

abstract class MainRepository {
  Future<Result<List<Track>>> getTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
    String time = 'week',
    String? genre,
  });
  Future<Result<List<Track>>> getUndergroundTrendingTracksFromApi({
    int offset = 0,
    int limit = 20,
  });
  Future<Result<List<Track>>> getFeelingLuckyTracksFromApi({int limit = 20});

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
  Future<Result<List<Track>>> searchTracks({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  });
  Future<Result<List<SearchUser>>> searchUsers({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  });
  Future<Result<List<SearchPlaylist>>> searchPlaylists({
    required String query,
    int offset = 0,
    int limit = 20,
    String sortMethod = 'relevant',
  });
  Stream<Result<List<Track>>> watchOfflineTracks();
  Future<Result<bool>> isTrackDownloaded(String trackId);
  Future<Result<void>> removeOfflineTrack(String trackId);
}
