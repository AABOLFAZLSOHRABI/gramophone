import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MediaItemCard extends StatelessWidget {
  const MediaItemCard({
    required this.title,
    required this.imageWidth,
    required this.imageHeight,
    super.key,
    this.subtitle,
    this.imageUrl,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? imageUrl;
  final double imageWidth;
  final double imageHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: imageWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MediaItemImage(
                imageUrl: imageUrl,
                width: imageWidth,
                height: imageHeight,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(
                  title,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty)
                Text(
                  subtitle!,
                  style: AppTextStyles.textHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaItemImage extends StatelessWidget {
  const _MediaItemImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String? imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return Image.asset(
        Assets.images.logoApp.path,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        width: width,
        height: height,
        color: AppColors.btmNavColor,
        child: Skeletonizer(
          enabled: true,
          child: Container(
            width: width,
            height: height,
            color: AppColors.textSecondary.withValues(alpha: 0.12),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Image.asset(
        Assets.images.logoApp.path,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
