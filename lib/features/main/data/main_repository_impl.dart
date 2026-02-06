import 'package:gramophone/features/main/data/datasources/audius_remote_data_source.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/features/main/models/track_model.dart';

class MainRepositoryImpl implements MainRepository {
  final AudiusRemoteDataSource _remote;

  MainRepositoryImpl(this._remote);

  @override
  Future<List<TrackModel>> getTrendingTracks() {
    return _remote.getTrendingTracks();
  }
}
