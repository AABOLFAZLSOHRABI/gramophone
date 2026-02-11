import 'package:flutter/material.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';

class SearchTabPage extends StatelessWidget {
  const SearchTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final stream = sl<MainRepository>().watchTrendingTracks();
              await for (final result in stream) {
                switch (result) {
                  case ResultSuccess():
                    final tracks = result.data;
                    if (tracks.isEmpty) {
                      print('No tracks found');
                      continue;
                    }
                    print(tracks.length);
                    print(tracks.first.title);
                    print(tracks.first.artist);
                    print(tracks.first.imageUrl);
                  case ResultFailure():
                    print(result.failure.message);
                }
              }
            },
            child: const Text('Test with GetIt'),
          ),
        ),
      ),
    );
  }
}
