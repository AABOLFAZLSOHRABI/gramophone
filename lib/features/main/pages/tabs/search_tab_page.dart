import 'package:flutter/material.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/features/main/data/datasources/audius_remote_data_source.dart';

class SearchTabPage extends StatelessWidget {
  const SearchTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ds = sl<AudiusRemoteDataSource>();
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final tracks = await sl<AudiusRemoteDataSource>()
                  .getTrendingTracks();

              print(tracks.length);
              print(tracks.first.title);
              print(tracks.first.user.name);
              print(tracks.first.artwork?.x480);
            },
            child: const Text('Test with GetIt'),
          ),
        ),
      ),
    );
  }
}
