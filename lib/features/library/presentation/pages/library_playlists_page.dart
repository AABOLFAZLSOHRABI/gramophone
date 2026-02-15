import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/features/library/domain/entities/library_playlist.dart';
import 'package:gramophone/features/library/presentation/cubit/library_cubit.dart';

class LibraryPlaylistsPage extends StatelessWidget {
  const LibraryPlaylistsPage({required this.playlists, super.key});

  final List<LibraryPlaylist> playlists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Playlists', style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: playlists.length,
        separatorBuilder: (_, __) => Divider(
          color: AppColors.textWhite.withValues(alpha: 0.08),
          height: 1.h,
        ),
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return ListTile(
            onTap: () => context.push(
              RouteNames.libraryPlaylistDetailPage,
              extra: playlist,
            ),
            title: Text(playlist.name, style: AppTextStyles.titleSmall),
            subtitle: Text(
              '${playlist.trackIds.length} tracks',
              style: AppTextStyles.textHint,
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'rename') {
                  _showRenameDialog(context, playlist);
                } else if (value == 'delete') {
                  context.read<LibraryCubit>().deletePlaylist(playlist.id);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'rename', child: Text('Rename')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create playlist'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<LibraryCubit>().createPlaylist(controller.text);
                Navigator.pop(dialogContext);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, LibraryPlaylist playlist) {
    final controller = TextEditingController(text: playlist.name);
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Rename playlist'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<LibraryCubit>().renamePlaylist(
                  playlist.id,
                  controller.text,
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
