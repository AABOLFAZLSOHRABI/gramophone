import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/features/library/domain/entities/library_track.dart';
import 'package:gramophone/features/library/presentation/cubit/library_cubit.dart';
import 'package:gramophone/features/library/presentation/cubit/library_state.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';
import 'package:gramophone/gen/assets.gen.dart';

class LibraryTracksPage extends StatelessWidget {
  const LibraryTracksPage({
    required this.title,
    required this.tracks,
    super.key,
  });

  final String title;
  final List<LibraryTrack> tracks;

  @override
  Widget build(BuildContext context) {
    final queue = tracks.map((item) => item.toTrack()).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(title, style: AppTextStyles.titleMedium),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        itemBuilder: (context, index) {
          final item = tracks[index];
          return _TrackTile(
            track: item,
            onTap: () {
              sl<PlayerBloc>().add(
                PlayTrackRequested(queue: queue, index: index, autoPlay: true),
              );
              context.push(RouteNames.playerPage, extra: queue[index]);
            },
            onMore: () => _showTrackActions(context, item),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemCount: tracks.length,
      ),
    );
  }

  void _showTrackActions(BuildContext context, LibraryTrack track) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.btmNavColor,
      builder: (sheetContext) {
        return BlocBuilder<LibraryCubit, LibraryState>(
          builder: (context, state) {
            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(track.title, style: AppTextStyles.titleMedium),
                    subtitle: Text(track.artist, style: AppTextStyles.textHint),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_border_rounded),
                    title: const Text('Toggle Like'),
                    onTap: () {
                      context.read<LibraryCubit>().toggleLike(track.id);
                      Navigator.pop(sheetContext);
                    },
                  ),
                  ...state.playlists.map(
                    (playlist) => ListTile(
                      leading: const Icon(Icons.playlist_add_rounded),
                      title: Text('Add to ${playlist.name}'),
                      onTap: () {
                        context.read<LibraryCubit>().addToPlaylist(
                          track.id,
                          playlist.id,
                        );
                        Navigator.pop(sheetContext);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _TrackTile extends StatelessWidget {
  const _TrackTile({
    required this.track,
    required this.onTap,
    required this.onMore,
  });

  final LibraryTrack track;
  final VoidCallback onTap;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final image = track.imageUrl?.trim();
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      tileColor: AppColors.textWhite.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: (image == null || image.isEmpty)
            ? Image.asset(
                Assets.images.logoApp.path,
                width: 48.w,
                height: 48.w,
                fit: BoxFit.cover,
              )
            : Image.network(
                image,
                width: 48.w,
                height: 48.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  Assets.images.logoApp.path,
                  width: 48.w,
                  height: 48.w,
                  fit: BoxFit.cover,
                ),
              ),
      ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.titleSmall,
      ),
      subtitle: Text(
        track.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.textHint,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (track.isLiked)
            Icon(Icons.favorite_rounded, color: AppColors.primary, size: 18.r),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: onMore,
          ),
        ],
      ),
    );
  }
}
