import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:gramophone/features/main/data/datasources/audius_remote_data_source.dart';
import 'package:gramophone/features/main/data/datasources/main_local_data_source.dart';
import 'package:gramophone/features/main/data/datasources/offline_download_data_source.dart';
import 'package:gramophone/features/main/data/main_repository_impl.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/features/main/presentation/cubit/home_cubit.dart';
import 'package:gramophone/features/player/data/datasources/player_local_data_source.dart';
import 'package:gramophone/features/player/data/player_repository_impl.dart';
import 'package:gramophone/features/player/data/services/just_audio_player_service.dart';
import 'package:gramophone/features/player/domain/repositories/player_repository.dart';
import 'package:gramophone/features/player/domain/services/audio_player_service.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1) Network
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // 2) DataSource
  sl.registerLazySingleton<AudiusRemoteDataSource>(
    () => AudiusRemoteDataSource(sl<DioClient>()),
  );
  sl.registerLazySingleton<MainLocalDataSource>(() => MainLocalDataSource());
  sl.registerLazySingleton<OfflineDownloadDataSource>(
    () => OfflineDownloadDataSource(),
  );

  sl.registerLazySingleton<MainRepository>(
    () => MainRepositoryImpl(sl(), sl(), sl(), sl()),
  );
  sl.registerLazySingleton<PlayerLocalDataSource>(
    () => PlayerLocalDataSource(),
  );
  sl.registerLazySingleton<AudioPlayer>(() => AudioPlayer());
  sl.registerLazySingleton<AudioPlayerService>(
    () => JustAudioPlayerService(sl<AudioPlayer>()),
  );
  sl.registerLazySingleton<PlayerRepository>(
    () => PlayerRepositoryImpl(
      sl<MainRepository>(),
      sl<OfflineDownloadDataSource>(),
      sl<PlayerLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<PlayerBloc>(
    () => PlayerBloc(sl<AudioPlayerService>(), sl<PlayerRepository>()),
  );
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<MainRepository>()));
}
