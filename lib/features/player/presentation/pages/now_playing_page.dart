import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';
import 'package:gramophone/features/player/presentation/bloc/player_state.dart';
import 'package:gramophone/gen/assets.gen.dart';

class NowPlayingScreen extends StatelessWidget {
  NowPlayingScreen({
    super.key,
    this.track,
    this.title = 'Track Title',
    this.artist = 'Artist Name',
    ImageProvider? albumImageProvider,
    this.current = const Duration(seconds: 0),
    this.total = const Duration(minutes: 3),
    this.isShuffleOn = false,
    this.isRepeatOn = true,
  }) : albumImageProvider =
           albumImageProvider ?? Assets.images.gramophoneBackground.provider();

  final Track? track;
  final String title;
  final String artist;
  final ImageProvider albumImageProvider;
  final Duration current;
  final Duration total;
  final bool isShuffleOn;
  final bool isRepeatOn;

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerState>(
      bloc: sl<PlayerBloc>(),
      listener: (context, state) {
        final message = state.errorMessage ?? state.infoMessage;
        if (message != null && message.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          sl<PlayerBloc>().add(const MessageConsumed());
        }
      },
      builder: (context, playerState) {
        final resolvedTrack = playerState.currentTrack ?? track;

        final trackTitle = resolvedTrack?.title.trim();
        final resolvedTitle = (trackTitle != null && trackTitle.isNotEmpty)
            ? trackTitle
            : title;

        final trackArtist = resolvedTrack?.artist.trim();
        final resolvedArtist = (trackArtist != null && trackArtist.isNotEmpty)
            ? trackArtist
            : artist;

        final cachedImageUrl = resolvedTrack?.imageUrl?.trim();
        final hasTrackImage =
            cachedImageUrl != null && cachedImageUrl.isNotEmpty;

        final resolvedTotal = playerState.duration > Duration.zero
            ? playerState.duration
            : total;
        final resolvedCurrent = playerState.position > Duration.zero
            ? playerState.position
            : current;
        final currentSeconds = resolvedCurrent.inSeconds.clamp(
          0,
          resolvedTotal.inSeconds == 0 ? 0 : resolvedTotal.inSeconds,
        );
        final totalSeconds = resolvedTotal.inSeconds == 0
            ? 1
            : resolvedTotal.inSeconds;
        final value = (currentSeconds / totalSeconds).clamp(0.0, 1.0);

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: hasTrackImage
                    ? CachedNetworkImage(
                        imageUrl: cachedImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Image(image: albumImageProvider, fit: BoxFit.cover),
                        errorWidget: (_, __, ___) =>
                            Image(image: albumImageProvider, fit: BoxFit.cover),
                      )
                    : Image(image: albumImageProvider, fit: BoxFit.cover),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          _GlassIconButton(
                            icon: Icons.keyboard_arrow_down_rounded,
                            onTap: () => Navigator.maybePop(context),
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _GlassIconButton(
                            icon: Icons.playlist_add_rounded,
                            onTap: resolvedTrack == null
                                ? () {}
                                : () => sl<PlayerBloc>().add(
                                    AddToPlaylistPressed(resolvedTrack.id),
                                  ),
                          ),
                          _GlassIconButton(
                            icon: Icons.download_rounded,
                            iconColor: playerState.isDownloaded
                                ? AppColors.primary
                                : AppColors.textWhite,
                            backgroundColor: playerState.isDownloaded
                                ? AppColors.primary.withValues(alpha: 0.18)
                                : null,
                            onTap: resolvedTrack == null
                                ? () {}
                                : () => sl<PlayerBloc>().add(
                                    DownloadPressed(resolvedTrack),
                                  ),
                          ),
                        ],
                      ),
                    ),
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
                                child: hasTrackImage
                                    ? CachedNetworkImage(
                                        imageUrl: cachedImageUrl,
                                        width: 74.w,
                                        height: 74.w,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Image(
                                          image: albumImageProvider,
                                          width: 74.w,
                                          height: 74.w,
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (_, __, ___) => Image(
                                          image: albumImageProvider,
                                          width: 74.w,
                                          height: 74.w,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image(
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
                                      resolvedTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.titleBoldSmall
                                          .copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                    ),
                                    4.h.height,
                                    Text(
                                      resolvedArtist,
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
                                onPressed: resolvedTrack == null
                                    ? null
                                    : () => sl<PlayerBloc>().add(
                                        ToggleLikePressed(resolvedTrack.id),
                                      ),
                                icon: Icon(
                                  playerState.isLiked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: playerState.isLiked
                                      ? AppColors.primary
                                      : AppColors.textWhite.withValues(
                                          alpha: 0.9,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          14.h.height,
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4.h,
                              inactiveTrackColor: AppColors.textWhite
                                  .withValues(alpha: 0.24),
                              activeTrackColor: AppColors.primary,
                              thumbColor: AppColors.primary,
                              overlayColor: AppColors.primary.withValues(
                                alpha: 0.2,
                              ),
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 5.r,
                              ),
                            ),
                            child: Slider(
                              value: value,
                              onChanged: (newValue) {
                                final target = Duration(
                                  seconds: (resolvedTotal.inSeconds * newValue)
                                      .round(),
                                );
                                sl<PlayerBloc>().add(SeekChanged(target));
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Row(
                              children: [
                                Text(
                                  _format(Duration(seconds: currentSeconds)),
                                  style: AppTextStyles.textHint.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '-${_format(resolvedTotal - Duration(seconds: currentSeconds))}',
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
                              _MiniIcon(
                                icon: Icons.skip_previous_rounded,
                                size: 34.r,
                                onTap: () => sl<PlayerBloc>().add(
                                  const PreviousPressed(),
                                ),
                              ),
                              _PlayButton(
                                isPlaying: playerState.isPlaying,
                                onTap: () => sl<PlayerBloc>().add(
                                  const TogglePlayPausePressed(),
                                ),
                              ),
                              _MiniIcon(
                                icon: Icons.skip_next_rounded,
                                size: 34.r,
                                onTap: () =>
                                    sl<PlayerBloc>().add(const NextPressed()),
                              ),
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
                                color: AppColors.primary.withValues(
                                  alpha: 0.28,
                                ),
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
                                  AppStrings.lyrics,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.textWhite,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  AppStrings.more,
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
      },
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppColors.background.withValues(alpha: 0.36),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textWhite,
            size: 22.r,
          ),
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
    this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      size: size,
      color: isActive
          ? AppColors.textWhite
          : AppColors.textWhite.withValues(alpha: 0.5),
    );

    if (onTap == null) {
      return iconWidget;
    }

    return IconButton(onPressed: onTap, icon: iconWidget);
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.isPlaying, required this.onTap});

  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
