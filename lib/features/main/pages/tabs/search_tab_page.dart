import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';

class SearchTabPage extends StatelessWidget {
  const SearchTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    const topGenres = [
      _SearchTileData(title: AppStrings.genreIndie, color: Color(0xFF2D5D46)),
      _SearchTileData(title: AppStrings.genrePop, color: Color(0xFF6C3DB7)),
    ];

    const popularPodcasts = [
      _SearchTileData(
        title: AppStrings.categoryNewsPolitics,
        color: Color(0xFF255BC2),
      ),
      _SearchTileData(
        title: AppStrings.categoryComedy,
        color: Color(0xFFC44D30),
      ),
    ];

    const browseAll = [
      _SearchTileData(
        title: AppStrings.categoryCharts,
        color: Color(0xFF7D64AE),
      ),
      _SearchTileData(
        title: AppStrings.categoryMadeForYou,
        color: Color(0xFF5B8C47),
      ),
      _SearchTileData(
        title: AppStrings.categoryPodcasts,
        color: Color(0xFF2A3D73),
      ),
      _SearchTileData(
        title: AppStrings.categoryWrapped2026,
        color: Color(0xFF8EA54A),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(15.w, 14.h, 15.w, 10.h),
              sliver: SliverToBoxAdapter(
                child: Text(AppStrings.search, style: AppTextStyles.titleLarge),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              sliver: SliverToBoxAdapter(
                child: _SearchField(
                  hint: AppStrings.searchHint,
                  onTap: () => context.push(RouteNames.searchInputPageLocation),
                ),
              ),
            ),
            SliverToBoxAdapter(child: 18.h.height),
            _SectionHeader(title: AppStrings.yourTopGenres),
            _TilesGrid(items: topGenres),
            SliverToBoxAdapter(child: 18.h.height),
            _SectionHeader(title: AppStrings.popularPodcastCategories),
            _TilesGrid(items: popularPodcasts),
            SliverToBoxAdapter(child: 18.h.height),
            _SectionHeader(title: AppStrings.browseAll),
            _TilesGrid(items: browseAll),
            SliverToBoxAdapter(child: 16.h.height),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textWhite,
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.textDark, size: 22.r),
              10.w.width,
              Expanded(
                child: Text(
                  hint,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h),
      sliver: SliverToBoxAdapter(
        child: Text(title, style: AppTextStyles.titleBoldSmall),
      ),
    );
  }
}

class _TilesGrid extends StatelessWidget {
  const _TilesGrid({required this.items});

  final List<_SearchTileData> items;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      sliver: SliverToBoxAdapter(
        child: Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: items
              .map(
                (item) => SizedBox(
                  width: 192.w,
                  height: 109.h,
                  child: _SearchTile(item: item),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SearchTileData {
  const _SearchTileData({required this.title, required this.color});

  final String title;
  final Color color;
}

class _SearchTile extends StatelessWidget {
  const _SearchTile({required this.item});

  final _SearchTileData item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: Material(
        color: item.color,
        child: InkWell(
          onTap: () {},
          child: Stack(
            children: [
              // Title
              Positioned(
                left: 12.w,
                top: 12.h,
                right: 70.w,
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium,
                ),
              ),

              // Rotated "Album" card
              Positioned(
                right: -10.w,
                bottom: -10.h,
                child: Transform.rotate(
                  angle: 0.35,
                  child: Container(
                    width: 66.w,
                    height: 66.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(6.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 14.r,
                          offset: Offset(0, 6.h),
                          color: Colors.black.withValues(alpha: 0.25),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Text(
                      'Album',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textHint.copyWith(
                        color: AppColors.textWhite.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                    ),
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
