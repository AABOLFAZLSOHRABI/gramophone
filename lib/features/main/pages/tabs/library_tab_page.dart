import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/gen/assets.gen.dart';

class LibraryTabPage extends StatelessWidget {
  const LibraryTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: StreamBuilder<Result<List<Track>>>(
          stream: sl<MainRepository>().watchOfflineTracks(),
          builder: (context, snapshot) {
            final offlineResult = snapshot.data;
            final downloadedCount = switch (offlineResult) {
              ResultSuccess<List<Track>>(data: final data) => data.length,
              _ => null,
            };

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const _LibraryHeader(),
                SliverToBoxAdapter(child: 14.h.height),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  sliver: SliverToBoxAdapter(
                    child: _QuickAccessGrid(downloadedCount: downloadedCount),
                  ),
                ),
                SliverToBoxAdapter(child: 18.h.height),
                _HorizontalMediaSection(
                  title: AppStrings.libraryRecentlyAdded,
                  items: _recentlyAddedItems,
                ),
                SliverToBoxAdapter(child: 18.h.height),
                _HorizontalMediaSection(
                  title: AppStrings.libraryYourAlbums,
                  items: _albumItems,
                ),
                SliverToBoxAdapter(child: 18.h.height),
                _DownloadedSection(offlineResult: offlineResult),
                SliverToBoxAdapter(child: 16.h.height),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LibraryHeader extends StatelessWidget {
  const _LibraryHeader();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(15.w, 14.h, 15.w, 0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Text(AppStrings.library, style: AppTextStyles.titleLarge),
            const Spacer(),
            _HeaderActionButton(icon: Icons.search_rounded),
            10.w.width,
            _HeaderActionButton(icon: Icons.add_rounded),
          ],
        ),
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textWhite.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppDimens.radiusButton),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppDimens.radiusButton),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(icon, size: 20.r, color: AppColors.textWhite),
        ),
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.downloadedCount});

  final int? downloadedCount;

  @override
  Widget build(BuildContext context) {
    final items = [
      const _QuickAccessItem(
        title: AppStrings.libraryAlbums,
        subtitle: AppStrings.libraryYourAlbums,
        icon: Icons.album_rounded,
      ),
      const _QuickAccessItem(
        title: AppStrings.libraryLikedSongs,
        subtitle: AppStrings.play,
        icon: Icons.favorite_rounded,
      ),
      _QuickAccessItem(
        title: AppStrings.libraryDownloaded,
        subtitle: AppStrings.download,
        icon: Icons.download_done_rounded,
        badge: downloadedCount,
      ),
      const _QuickAccessItem(
        title: AppStrings.libraryPlaylists,
        subtitle: AppStrings.addToPlaylist,
        icon: Icons.queue_music_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.libraryQuickAccess,
          style: AppTextStyles.titleBoldSmall,
        ),
        10.h.height,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 2.45,
          ),
          itemBuilder: (context, index) {
            return _QuickAccessTile(item: items[index]);
          },
        ),
      ],
    );
  }
}

class _QuickAccessItem {
  const _QuickAccessItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badge,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final int? badge;
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({required this.item});

  final _QuickAccessItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textWhite.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(AppDimens.radiusCard * 2),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppDimens.radiusCard * 2),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: AppColors.primary, size: 19.r),
              ),
              10.w.width,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    2.h.height,
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textHint,
                    ),
                  ],
                ),
              ),
              if (item.badge != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    '${item.badge}',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HorizontalMediaSection extends StatelessWidget {
  const _HorizontalMediaSection({required this.title, required this.items});

  final String title;
  final List<_MockMediaItem> items;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title, style: AppTextStyles.titleBoldSmall),
                ),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    child: Text(
                      AppStrings.librarySeeAll,
                      style: AppTextStyles.textHint,
                    ),
                  ),
                ),
              ],
            ),
            10.h.height,
            SizedBox(
              height: 172.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => 10.w.width,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _MockMediaCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockMediaItem {
  const _MockMediaItem({
    required this.title,
    required this.subtitle,
    this.imagePath,
  });

  final String title;
  final String subtitle;
  final String? imagePath;
}

class _MockMediaCard extends StatelessWidget {
  const _MockMediaCard({required this.item});

  final _MockMediaItem item;

  @override
  Widget build(BuildContext context) {
    final imagePath = item.imagePath ?? Assets.images.logoApp.path;

    return SizedBox(
      width: 138.w,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppDimens.radiusCard * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusCard * 2),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              6.h.height,
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall,
              ),
              Text(
                item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadedSection extends StatelessWidget {
  const _DownloadedSection({required this.offlineResult});

  final Result<List<Track>>? offlineResult;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.libraryDownloaded,
              style: AppTextStyles.titleBoldSmall,
            ),
            10.h.height,
            Builder(
              builder: (context) {
                if (offlineResult == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return switch (offlineResult!) {
                  ResultSuccess<List<Track>>(data: final tracks) =>
                    tracks.isEmpty
                        ? const _EmptyDownloadedState()
                        : Column(
                            children: tracks
                                .map(
                                  (track) => _DownloadedTrackItem(track: track),
                                )
                                .toList(),
                          ),
                  ResultFailure<List<Track>>(failure: final failure) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      failure.message,
                      style: AppTextStyles.textHint,
                      textAlign: TextAlign.center,
                    ),
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDownloadedState extends StatelessWidget {
  const _EmptyDownloadedState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard * 2),
        border: Border.all(color: AppColors.textWhite.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textWhite.withValues(alpha: 0.08),
            ),
            child: Icon(
              Icons.download_for_offline_outlined,
              color: AppColors.textSecondary,
              size: 20.r,
            ),
          ),
          10.w.width,
          Expanded(
            child: Text(
              AppStrings.libraryDownloadsEmptyHint,
              style: AppTextStyles.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadedTrackItem extends StatelessWidget {
  const _DownloadedTrackItem({required this.track});

  final Track track;

  @override
  Widget build(BuildContext context) {
    final imageSource = track.imageUrl?.trim();
    final hasLocalImage =
        imageSource != null &&
        imageSource.isNotEmpty &&
        !imageSource.startsWith('http');
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: AppColors.textWhite.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard * 2),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppDimens.radiusCard * 2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusCard * 2),
                  child: hasLocalImage
                      ? Image.file(
                          File(imageSource),
                          width: 58.w,
                          height: 58.h,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          Assets.images.logoApp.path,
                          width: 58.w,
                          height: 58.h,
                          fit: BoxFit.cover,
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
                        style: AppTextStyles.titleMedium,
                      ),
                      2.h.height,
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textHint,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.play_circle_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 23.r,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _recentlyAddedItems = [
  _MockMediaItem(title: 'Summer Echoes', subtitle: 'Playlist', imagePath: null),
  _MockMediaItem(title: 'Midnight Drive', subtitle: 'Album', imagePath: null),
  _MockMediaItem(title: 'Acoustic Flow', subtitle: 'Playlist', imagePath: null),
  _MockMediaItem(
    title: 'Vibe Archive',
    subtitle: 'Collection',
    imagePath: null,
  ),
];

const _albumItems = [
  _MockMediaItem(
    title: 'Blue Signals',
    subtitle: 'by Gramophone',
    imagePath: null,
  ),
  _MockMediaItem(
    title: 'Analog Bloom',
    subtitle: 'by Gramophone',
    imagePath: null,
  ),
  _MockMediaItem(
    title: 'Neon Shore',
    subtitle: 'by Gramophone',
    imagePath: null,
  ),
  _MockMediaItem(
    title: 'Lowlight Stories',
    subtitle: 'by Gramophone',
    imagePath: null,
  ),
];
