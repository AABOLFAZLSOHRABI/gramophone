import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/features/library/domain/entities/library_section.dart';
import 'package:gramophone/features/library/domain/entities/library_sort.dart';
import 'package:gramophone/features/library/domain/entities/library_source_type.dart';
import 'package:gramophone/features/library/domain/entities/library_track.dart';
import 'package:gramophone/features/library/presentation/cubit/library_cubit.dart';
import 'package:gramophone/features/library/presentation/cubit/library_state.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';
import 'package:gramophone/gen/assets.gen.dart';

class LibraryTabPage extends StatelessWidget {
  const LibraryTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LibraryCubit>()..initialize(),
      child: const _LibraryBody(),
    );
  }
}

class _LibraryBody extends StatelessWidget {
  const _LibraryBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<LibraryCubit, LibraryState>(
          listener: (context, state) {
            final message = state.errorMessage ?? state.infoMessage;
            if (message == null || message.isEmpty) {
              return;
            }
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
            context.read<LibraryCubit>().clearMessage();
          },
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(15.w, 14.h, 15.w, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          AppStrings.library,
                          style: AppTextStyles.titleLarge,
                        ),
                        const Spacer(),
                        _HeaderAction(
                          icon: Icons.refresh_rounded,
                          onTap: () {
                            if (state.source == LibrarySourceType.local) {
                              context.read<LibraryCubit>().scanLocal();
                            } else {
                              context.read<LibraryCubit>().refreshGram();
                            }
                          },
                        ),
                        10.w.width,
                        _HeaderAction(
                          icon: Icons.folder_open_rounded,
                          onTap: () => context.read<LibraryCubit>().scanLocal(
                            pickFoldersOnDesktop: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: 12.h.height),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  sliver: SliverToBoxAdapter(
                    child: _SourceSwitcher(
                      source: state.source,
                      onChanged: context.read<LibraryCubit>().setSource,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: 12.h.height),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  sliver: SliverToBoxAdapter(
                    child: _SearchAndSortBar(state: state),
                  ),
                ),
                SliverToBoxAdapter(child: 12.h.height),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  sliver: SliverToBoxAdapter(
                    child: _QuickAccessCards(state: state),
                  ),
                ),
                SliverToBoxAdapter(child: 12.h.height),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  sliver: SliverToBoxAdapter(
                    child: _QuickAccessChips(state: state),
                  ),
                ),
                SliverToBoxAdapter(child: 12.h.height),
                if (state.isLoading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  if (state.section == LibrarySection.albums)
                    _AlbumsSliver(state: state)
                  else if (state.section == LibrarySection.playlists)
                    _PlaylistsSliver(state: state)
                  else
                    _TracksSliver(state: state),
                ],
                SliverToBoxAdapter(child: 16.h.height),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textWhite.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppDimens.radiusButton),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusButton),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(icon, size: 20.r, color: AppColors.textWhite),
        ),
      ),
    );
  }
}

class _SourceSwitcher extends StatelessWidget {
  const _SourceSwitcher({required this.source, required this.onChanged});

  final LibrarySourceType source;
  final ValueChanged<LibrarySourceType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textWhite.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SourceTab(
              label: 'Local',
              selected: source == LibrarySourceType.local,
              onTap: () => onChanged(LibrarySourceType.local),
            ),
          ),
          Expanded(
            child: _SourceTab(
              label: 'Gram',
              selected: source == LibrarySourceType.gram,
              onTap: () => onChanged(LibrarySourceType.gram),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceTab extends StatelessWidget {
  const _SourceTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: EdgeInsets.all(4.r),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.titleSmall.copyWith(
              color: selected ? AppColors.textDark : AppColors.textWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchAndSortBar extends StatelessWidget {
  const _SearchAndSortBar({required this.state});

  final LibraryState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: context.read<LibraryCubit>().setQuery,
            style: AppTextStyles.titleSmall,
            decoration: InputDecoration(
              hintText: AppStrings.searchHint,
              hintStyle: AppTextStyles.textHint,
              filled: true,
              fillColor: AppColors.textWhite.withValues(alpha: 0.06),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 20.r,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
          ),
        ),
        8.w.width,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: AppColors.textWhite.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<LibrarySort>(
              value: state.sort,
              dropdownColor: AppColors.btmNavColor,
              items: const [
                DropdownMenuItem(value: LibrarySort.title, child: Text('Name')),
                DropdownMenuItem(
                  value: LibrarySort.artist,
                  child: Text('Artist'),
                ),
                DropdownMenuItem(
                  value: LibrarySort.dateAdded,
                  child: Text('Date Added'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<LibraryCubit>().setSort(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAccessCards extends StatelessWidget {
  const _QuickAccessCards({required this.state});

  final LibraryState state;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: Icons.library_music_rounded,
        label: 'All Songs',
        value: state.activeTracks.length.toString(),
        section: LibrarySection.allTracks,
      ),
      (
        icon: Icons.album_rounded,
        label: 'Albums',
        value: state.activeAlbums.length.toString(),
        section: LibrarySection.albums,
      ),
      (
        icon: Icons.download_done_rounded,
        label: 'Downloaded',
        value: state.downloadedTracks.length.toString(),
        section: LibrarySection.downloaded,
      ),
      (
        icon: Icons.favorite_rounded,
        label: 'Liked',
        value: state.likedTracks.length.toString(),
        section: LibrarySection.liked,
      ),
      (
        icon: Icons.queue_music_rounded,
        label: 'Playlists',
        value: state.playlists.length.toString(),
        section: LibrarySection.playlists,
      ),
    ];
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: items.map((item) {
        return SizedBox(
          width: 122.w,
          child: Material(
            color: AppColors.textWhite.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              onTap: () =>
                  context.read<LibraryCubit>().setSection(item.section),
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon, color: AppColors.primary, size: 18.r),
                    10.h.height,
                    Text(item.value, style: AppTextStyles.titleMedium),
                    Text(item.label, style: AppTextStyles.textHint),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAccessChips extends StatelessWidget {
  const _QuickAccessChips({required this.state});

  final LibraryState state;

  @override
  Widget build(BuildContext context) {
    final items = const [
      (LibrarySection.allTracks, 'All Songs'),
      (LibrarySection.albums, 'Albums'),
      (LibrarySection.downloaded, 'Downloaded'),
      (LibrarySection.liked, 'Liked'),
      (LibrarySection.playlists, 'Playlists'),
    ];
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items.map((entry) {
        final selected = state.section == entry.$1;
        return ChoiceChip(
          label: Text(entry.$2),
          selected: selected,
          selectedColor: AppColors.primary,
          labelStyle: AppTextStyles.titleSmall.copyWith(
            color: selected ? AppColors.textDark : AppColors.textWhite,
            fontWeight: FontWeight.w600,
          ),
          onSelected: (_) => context.read<LibraryCubit>().setSection(entry.$1),
          backgroundColor: AppColors.textWhite.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
            side: BorderSide.none,
          ),
        );
      }).toList(),
    );
  }
}

class _TracksSliver extends StatelessWidget {
  const _TracksSliver({required this.state});

  final LibraryState state;

  @override
  Widget build(BuildContext context) {
    final tracks = state.activeTracks;
    if (tracks.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No tracks found', style: AppTextStyles.textHint),
        ),
      );
    }
    final queue = tracks.map((item) => item.toTrack()).toList();
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      sliver: SliverList.separated(
        itemCount: tracks.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final item = tracks[index];
          return _TrackCard(
            track: item,
            onTap: () {
              sl<PlayerBloc>().add(
                PlayTrackRequested(queue: queue, index: index, autoPlay: true),
              );
              context.push(RouteNames.playerPage, extra: queue[index]);
            },
            onMore: () => _showTrackActions(context, state, item),
          );
        },
      ),
    );
  }

  void _showTrackActions(
    BuildContext context,
    LibraryState state,
    LibraryTrack track,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.btmNavColor,
      builder: (_) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(track.title, style: AppTextStyles.titleMedium),
                subtitle: Text(track.artist, style: AppTextStyles.textHint),
              ),
              ListTile(
                leading: Icon(
                  track.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
                title: Text(track.isLiked ? 'Unlike' : 'Like'),
                onTap: () {
                  context.read<LibraryCubit>().toggleLike(track.id);
                  Navigator.pop(context);
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
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrackCard extends StatelessWidget {
  const _TrackCard({
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
    return Material(
      color: AppColors.textWhite.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: (image == null || image.isEmpty)
                    ? Image.asset(
                        Assets.images.logoApp.path,
                        width: 52.w,
                        height: 52.h,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        image,
                        width: 52.w,
                        height: 52.h,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          Assets.images.logoApp.path,
                          width: 52.w,
                          height: 52.h,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              10.w.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall,
                    ),
                    Text(
                      track.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textHint,
                    ),
                  ],
                ),
              ),
              if (track.isLiked)
                Icon(
                  Icons.favorite_rounded,
                  color: AppColors.primary,
                  size: 18.r,
                ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: onMore,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlbumsSliver extends StatelessWidget {
  const _AlbumsSliver({required this.state});

  final LibraryState state;

  @override
  Widget build(BuildContext context) {
    final albums = state.activeAlbums;
    if (albums.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No albums found', style: AppTextStyles.textHint),
        ),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.82,
        ),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          final image = album.imageUrl?.trim();
          return Material(
            color: AppColors.textWhite.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () =>
                  context.push(RouteNames.libraryAlbumDetailPage, extra: album),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: (image == null || image.isEmpty)
                          ? Image.asset(
                              Assets.images.logoApp.path,
                              width: double.infinity,
                              height: 120.h,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              image,
                              width: double.infinity,
                              height: 120.h,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                Assets.images.logoApp.path,
                                width: double.infinity,
                                height: 120.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      album.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall,
                    ),
                    Text(
                      album.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textHint,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlaylistsSliver extends StatelessWidget {
  const _PlaylistsSliver({required this.state});

  final LibraryState state;

  @override
  Widget build(BuildContext context) {
    if (state.playlists.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No playlists yet', style: AppTextStyles.textHint),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      sliver: SliverList.separated(
        itemCount: state.playlists.length + 1,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Material(
              color: AppColors.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () => _showCreateDialog(context),
                child: const ListTile(
                  leading: Icon(Icons.add_rounded),
                  title: Text('Create Playlist'),
                ),
              ),
            );
          }
          final playlist = state.playlists[index - 1];
          return Material(
            color: AppColors.textWhite.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () => context.push(
                RouteNames.libraryPlaylistDetailPage,
                extra: playlist,
              ),
              child: ListTile(
                title: Text(playlist.name, style: AppTextStyles.titleSmall),
                subtitle: Text(
                  '${playlist.trackIds.length} tracks',
                  style: AppTextStyles.textHint,
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      context.read<LibraryCubit>().deletePlaylist(playlist.id);
                    } else if (value == 'rename') {
                      _renamePlaylist(context, playlist.id, playlist.name);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'rename', child: Text('Rename')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
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

  void _renamePlaylist(BuildContext context, String id, String currentName) {
    final controller = TextEditingController(text: currentName);
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
                  id,
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
