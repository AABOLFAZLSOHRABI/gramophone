import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/router/app_router.dart';
import 'package:gramophone/core/ui/theme/app_theme.dart';
import 'package:gramophone/features/main/data/datasources/main_local_data_source.dart';
import 'package:gramophone/features/main/data/datasources/offline_download_data_source.dart';
import 'package:gramophone/features/player/data/datasources/player_local_data_source.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(MainLocalDataSource.trendingCacheBoxName);
  await Hive.openBox<dynamic>(OfflineDownloadDataSource.offlineTracksBoxName);
  await Hive.openBox<dynamic>(PlayerLocalDataSource.likesBoxName);
  await Hive.openBox<dynamic>(PlayerLocalDataSource.playlistsBoxName);
  await setupServiceLocator();
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    const windowSize = Size(428, 926);
    await windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: windowSize,
        minimumSize: windowSize,
        maximumSize: windowSize,
        center: true,
        title: 'gram',
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'gram',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark(),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
