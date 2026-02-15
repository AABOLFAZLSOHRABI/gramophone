import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/features/library/domain/entities/library_album.dart';
import 'package:gramophone/gen/assets.gen.dart';

class LibraryAlbumDetailPage extends StatelessWidget {
  const LibraryAlbumDetailPage({required this.album, super.key});

  final LibraryAlbum album;

  @override
  Widget build(BuildContext context) {
    final image = album.imageUrl?.trim();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: (image == null || image.isEmpty)
                      ? Image.asset(
                          Assets.images.logoApp.path,
                          width: 90.w,
                          height: 90.h,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          image,
                          width: 90.w,
                          height: 90.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            Assets.images.logoApp.path,
                            width: 90.w,
                            height: 90.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(album.title, style: AppTextStyles.titleMedium),
                      Text(album.artist, style: AppTextStyles.textHint),
                      SizedBox(height: 8.h),
                      ElevatedButton(
                        onPressed: () {
                          context.push(
                            RouteNames.libraryTracksPage,
                            extra: {
                              'title': album.title,
                              'tracks': album.tracks,
                            },
                          );
                        },
                        child: const Text('Show Tracks'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Text('Tracks', style: AppTextStyles.titleMedium),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: album.tracks.length,
                itemBuilder: (_, index) {
                  final item = album.tracks[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall,
                    ),
                    subtitle: Text(item.artist, style: AppTextStyles.textHint),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
