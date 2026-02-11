import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({
    super.key,
    this.title = 'Track Title',
    this.artist = 'Artist Name',
    ImageProvider? albumImageProvider,
    this.current = const Duration(seconds: 0),
    this.total = const Duration(minutes: 3),
    this.isPlaying = true,
    this.isShuffleOn = false,
    this.isRepeatOn = true,
  }) : albumImageProvider =
           albumImageProvider ?? const AssetImage('assets/images/logoApp.jpg');

  final String title;
  final String artist;
  final ImageProvider albumImageProvider;
  final Duration current;
  final Duration total;
  final bool isPlaying;
  final bool isShuffleOn;
  final bool isRepeatOn;

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final totalSeconds = total.inSeconds == 0 ? 1 : total.inSeconds;
    final value = (current.inSeconds / totalSeconds).clamp(0.0, 1.0);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: albumImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.22),
                    AppColors.background.withValues(alpha: 0.62),
                    AppColors.background.withValues(alpha: 0.96),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    children: [
                      _GlassIconButton(
                        icon: Icons.keyboard_arrow_down_rounded,
                        onTap: () => Navigator.maybePop(context),
                      ),
                      const Spacer(),
                      Text(
                        'NOW PLAYING',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textWhite.withValues(alpha: 0.9),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      _GlassIconButton(
                        icon: Icons.more_horiz_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 18.h),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.84),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(26.r),
                    ),
                    border: Border.all(
                      color: AppColors.textWhite.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image(
                              image: albumImageProvider,
                              width: 74.w,
                              height: 74.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          12.w.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.titleBoldSmall.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                4.h.height,
                                Text(
                                  artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.textHint.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border_rounded,
                              color: AppColors.textWhite.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                      14.h.height,
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4.h,
                          inactiveTrackColor: AppColors.textWhite.withValues(
                            alpha: 0.24,
                          ),
                          activeTrackColor: AppColors.primary,
                          thumbColor: AppColors.primary,
                          overlayColor: AppColors.primary.withValues(alpha: 0.2),
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 5.r,
                          ),
                        ),
                        child: Slider(
                          value: value,
                          onChanged: (_) {},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Row(
                          children: [
                            Text(
                              _format(current),
                              style: AppTextStyles.textHint.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '-${_format(total - current)}',
                              style: AppTextStyles.textHint.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.h.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _MiniIcon(
                            icon: Icons.shuffle_rounded,
                            isActive: isShuffleOn,
                          ),
                          _MiniIcon(icon: Icons.skip_previous_rounded, size: 34.r),
                          _PlayButton(isPlaying: isPlaying),
                          _MiniIcon(icon: Icons.skip_next_rounded, size: 34.r),
                          _MiniIcon(
                            icon: Icons.repeat_rounded,
                            isActive: isRepeatOn,
                          ),
                        ],
                      ),
                      12.h.height,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.graphic_eq_rounded,
                              color: AppColors.primary,
                              size: 20.r,
                            ),
                            8.w.width,
                            Text(
                              'Lyrics',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.textWhite,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'MORE',
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColors.textWhite,
                              ),
                            ),
                            6.w.width,
                            Icon(
                              Icons.open_in_full_rounded,
                              color: AppColors.textWhite,
                              size: 16.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background.withValues(alpha: 0.36),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(icon, color: AppColors.textWhite, size: 22.r),
        ),
      ),
    );
  }
}

class _MiniIcon extends StatelessWidget {
  const _MiniIcon({
    required this.icon,
    this.isActive = true,
    this.size = 24,
  });

  final IconData icon;
  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: isActive
          ? AppColors.textWhite
          : AppColors.textWhite.withValues(alpha: 0.5),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.w,
      height: 62.w,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: AppColors.textDark,
        size: 34.r,
      ),
    );
  }
}
