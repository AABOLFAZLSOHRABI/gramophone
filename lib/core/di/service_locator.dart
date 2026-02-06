import 'package:get_it/get_it.dart';
import 'package:gramophone/features/main/data/datasources/audius_remote_data_source.dart';
import 'package:gramophone/features/main/data/main_repository_impl.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1) Network
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // 2) DataSource
  sl.registerLazySingleton<AudiusRemoteDataSource>(
    () => AudiusRemoteDataSource(sl<DioClient>()),
  );
  sl.registerLazySingleton<MainRepository>(() => MainRepositoryImpl(sl()));
}
