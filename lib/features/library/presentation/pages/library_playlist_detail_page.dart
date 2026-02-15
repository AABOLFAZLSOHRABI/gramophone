import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/features/library/domain/entities/library_playlist.dart';
import 'package:gramophone/features/library/domain/entities/library_track.dart';
import 'package:gramophone/features/library/presentation/cubit/library_cubit.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';

class LibraryPlaylistDetailPage extends StatefulWidget {
  const LibraryPlaylistDetailPage({required this.playlist, super.key});

  final LibraryPlaylist playlist;

  @override
  State<LibraryPlaylistDetailPage> createState() =>
      _LibraryPlaylistDetailPageState();
}

class _LibraryPlaylistDetailPageState extends State<LibraryPlaylistDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.playlist.name, style: AppTextStyles.titleMedium),
      ),
      body: FutureBuilder<List<LibraryTrack>>(
        future: context.read<LibraryCubit>().getTracksForPlaylist(
          widget.playlist.id,
        ),
        builder: (context, snapshot) {
          final tracks = snapshot.data ?? const <LibraryTrack>[];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tracks.isEmpty) {
            return Center(
              child: Text(
                'No tracks in playlist',
                style: AppTextStyles.textHint,
              ),
            );
          }
          final queue = tracks.map((item) => item.toTrack()).toList();
          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (_, index) {
              final track = tracks[index];
              return ListTile(
                title: Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall,
                ),
                subtitle: Text(track.artist, style: AppTextStyles.textHint),
                onTap: () {
                  sl<PlayerBloc>().add(
                    PlayTrackRequested(
                      queue: queue,
                      index: index,
                      autoPlay: true,
                    ),
                  );
                  context.push(RouteNames.playerPage, extra: queue[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
