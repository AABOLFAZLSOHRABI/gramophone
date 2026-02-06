import 'package:gramophone/features/main/models/track_model.dart';

abstract class MainRepository {
  Future<List<TrackModel>> getTrendingTracks();
}
