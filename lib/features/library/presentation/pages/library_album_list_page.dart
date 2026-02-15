import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/features/library/domain/entities/library_album.dart';
import 'package:gramophone/gen/assets.gen.dart';

class LibraryAlbumListPage extends StatelessWidget {
  const LibraryAlbumListPage({
    required this.title,
    required this.albums,
    super.key,
  });

  final String title;
  final List<LibraryAlbum> albums;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(title, style: AppTextStyles.titleMedium),
      ),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.83,
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
                padding: EdgeInsets.all(10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: (image == null || image.isEmpty)
                          ? Image.asset(
                              Assets.images.logoApp.path,
                              height: 120.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              image,
                              height: 120.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                Assets.images.logoApp.path,
                                height: 120.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    SizedBox(height: 8.h),
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
                    Text(
                      '${album.tracks.length} tracks',
                      style: AppTextStyles.textHint.copyWith(fontSize: 11.sp),
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
