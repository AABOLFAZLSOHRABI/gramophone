import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/gen/assets.gen.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({
    required this.track,
    required this.isPlaying,
    required this.onTap,
    required this.onTogglePlayPause,
    required this.onNext,
    super.key,
  });

  final Track track;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 6.h),
        child: Tooltip(
          message: AppStrings.miniPlayerOpen,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            child: Container(
              height: 62.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: AppColors.btmNavColor,
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              ),
              child: Row(
                children: [
                  _MiniArtwork(imageUrl: track.imageUrl),
                  10.w.width,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                        2.h.height,
                        Text(
                          track.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.textHint.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tooltip(
                    message: AppStrings.miniPlayerPlayPause,
                    child: IconButton(
                      onPressed: onTogglePlayPause,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: AppColors.textWhite,
                        size: 24.r,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: AppStrings.miniPlayerNext,
                    child: IconButton(
                      onPressed: onNext,
                      icon: Icon(
                        Icons.skip_next_rounded,
                        color: AppColors.textWhite,
                        size: 24.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniArtwork extends StatelessWidget {
  const _MiniArtwork({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Image.asset(
          Assets.images.logoApp.path,
          width: 42.w,
          height: 42.w,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: CachedNetworkImage(
        imageUrl: url,
        width: 42.w,
        height: 42.w,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => Image.asset(
          Assets.images.logoApp.path,
          width: 42.w,
          height: 42.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
