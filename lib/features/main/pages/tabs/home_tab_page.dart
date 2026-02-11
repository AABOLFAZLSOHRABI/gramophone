import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/domain/entities/review_item.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/presentation/cubit/home_cubit.dart';
import 'package:gramophone/features/main/presentation/cubit/home_state.dart';
import 'package:gramophone/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadHome(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const _HomeSkeletonView();
            }

            if (state is HomeError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message.isEmpty
                            ? AppStrings.somethingWentWrong
                            : state.message,
                        style: AppTextStyles.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      14.h.height,
                      ElevatedButton(
                        onPressed: () => context.read<HomeCubit>().loadHome(),
                        child: const Text(AppStrings.retry),
                      ),
                    ],
                  ),
                ),
              );
            }

            final loaded = state as HomeLoaded;
            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().loadHome(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    25.h.height,
                    _SectionHeader(title: AppStrings.recentlyPlayed),
                    10.h.height,
                    _TrackHorizontalList(
                      tracks: loaded.recentlyPlayed,
                      imageHeight: 105.h,
                      imageWidth: 105.w,
                      listHeight: 154.h,
                    ),
                    if (loaded.recentlyError != null) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          loaded.recentlyError!,
                          style: AppTextStyles.textHint.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      10.h.height,
                    ],
                    _ReviewSection(items: loaded.reviewItems),
                    if (loaded.reviewError != null) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          loaded.reviewError!,
                          style: AppTextStyles.textHint.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      10.h.height,
                    ],
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 15.w,
                      ),
                      child: Text(
                        AppStrings.editorsPicks,
                        style: AppTextStyles.titleLarge,
                      ),
                    ),
                    _TrackHorizontalList(
                      tracks: loaded.editorsPicks,
                      imageHeight: 155.h,
                      imageWidth: 155.w,
                      listHeight: 208.h,
                    ),
                    if (loaded.editorsError != null) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          loaded.editorsError!,
                          style: AppTextStyles.textHint.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      10.h.height,
                    ],
                    16.h.height,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.titleBoldSmall),
          const Spacer(),
          SvgPicture.asset(Assets.icons.alert),
          Padding(
            padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 0),
            child: SvgPicture.asset(Assets.icons.orientationLock),
          ),
          SvgPicture.asset(Assets.icons.settings),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.items});

  final List<ReviewItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _ReviewPlaceholder();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 15.h, bottom: 15.h),
          child: SizedBox(
            height: 60.h,
            child: Row(
              children: [
                Image.asset(
                  Assets.images.logoApp.path,
                  height: 58.h,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.gramophoneWrapped,
                        style: AppTextStyles.textHint,
                      ),
                      Text(
                        AppStrings.your2026InReview,
                        style: AppTextStyles.titleBold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 208.h,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemBuilder: (_, index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: SizedBox(
                  width: 155.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TrackImage(
                        imageUrl: item.imageUrl,
                        width: 155.w,
                        height: 155.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          item.title,
                          style: AppTextStyles.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        style: AppTextStyles.textHint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ReviewPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 15.h, bottom: 15.h),
          child: SizedBox(
            height: 60.h,
            child: Row(
              children: [
                Image.asset(
                  Assets.images.logoApp.path,
                  height: 58.h,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.gramophoneWrapped,
                        style: AppTextStyles.textHint,
                      ),
                      Text(
                        AppStrings.your2026InReview,
                        style: AppTextStyles.titleBold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 208.h,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            itemBuilder: (_, __) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Assets.images.logoApp.path,
                      height: 155.h,
                      width: 155.w,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text(
                        AppStrings.appName,
                        style: AppTextStyles.titleSmall,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TrackHorizontalList extends StatelessWidget {
  const _TrackHorizontalList({
    required this.tracks,
    required this.imageHeight,
    required this.imageWidth,
    required this.listHeight,
  });

  final List<Track> tracks;
  final double imageHeight;
  final double imageWidth;
  final double listHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listHeight,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: tracks.length,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemBuilder: (context, index) {
          final track = tracks[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: SizedBox(
              width: imageWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TrackImage(
                    imageUrl: track.imageUrl,
                    width: imageWidth,
                    height: imageHeight,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: Text(
                      track.title,
                      style: AppTextStyles.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    track.artist,
                    style: AppTextStyles.textHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TrackImage extends StatelessWidget {
  const _TrackImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String? imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
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

class _HomeSkeletonView extends StatelessWidget {
  const _HomeSkeletonView();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            25.h.height,
            const _SectionHeader(title: AppStrings.recentlyPlayed),
            10.h.height,
            _TrackHorizontalList(
              tracks: List.generate(
                6,
                (index) => Track(
                  id: 's-$index',
                  title: 'Loading title',
                  artist: 'Loading artist',
                  imageUrl: null,
                ),
              ),
              imageHeight: 105.h,
              imageWidth: 105.w,
              listHeight: 154.h,
            ),
            _ReviewPlaceholder(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: Text(
                AppStrings.editorsPicks,
                style: AppTextStyles.titleLarge,
              ),
            ),
            _TrackHorizontalList(
              tracks: List.generate(
                10,
                (index) => Track(
                  id: 'p-$index',
                  title: 'Loading title',
                  artist: 'Loading artist',
                  imageUrl: null,
                ),
              ),
              imageHeight: 155.h,
              imageWidth: 155.w,
              listHeight: 208.h,
            ),
          ],
        ),
      ),
    );
  }
}
