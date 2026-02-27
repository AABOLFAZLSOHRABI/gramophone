import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/foundations/app_dimens.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_colors.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/domain/entities/search_playlist.dart';
import 'package:gramophone/domain/entities/search_user.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/presentation/cubit/search_cubit.dart';
import 'package:gramophone/features/main/presentation/cubit/search_state.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';
import 'package:gramophone/gen/assets.gen.dart';

class SearchInputPage extends StatelessWidget {
  const SearchInputPage({
    super.key,
    this.cubit,
    this.initialGenre,
    this.initialAction,
  });

  final SearchCubit? cubit;
  final String? initialGenre;
  final Map<String, dynamic>? initialAction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit ?? sl<SearchCubit>(),
      child: _SearchInputView(
        initialGenre: initialGenre,
        initialAction: initialAction,
      ),
    );
  }
}

class _SearchInputView extends StatefulWidget {
  const _SearchInputView({this.initialGenre, this.initialAction});

  final String? initialGenre;
  final Map<String, dynamic>? initialAction;

  @override
  State<_SearchInputView> createState() => _SearchInputViewState();
}

class _SearchInputViewState extends State<_SearchInputView> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final initialAction = widget.initialAction;
    if (initialAction != null && initialAction.isNotEmpty) {
      final mode = (initialAction['mode'] as String?)?.trim();
      final value = (initialAction['value'] as String?)?.trim();
      final title = (initialAction['title'] as String?)?.trim();
      if (mode != null && mode.isNotEmpty) {
        _queryController.text = value ?? title ?? '';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          _loadByInitialAction(mode: mode, value: value, title: title);
        });
        return;
      }
    }
    final initialGenre = widget.initialGenre?.trim();
    if (initialGenre != null && initialGenre.isNotEmpty) {
      _queryController.text = initialGenre;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        context.read<SearchCubit>().loadTrendingByGenre(genre: initialGenre);
      });
    }
  }

  void _loadByInitialAction({
    required String mode,
    String? value,
    String? title,
  }) {
    final cubit = context.read<SearchCubit>();
    switch (mode) {
      case 'genreTrending':
        cubit.loadTrendingByGenre(genre: value ?? '', title: title);
        return;
      case 'tracksTrending':
        cubit.loadTrendingAll(title: title);
        return;
      case 'tracksUnderground':
        cubit.loadUndergroundTrending(title: title);
        return;
      case 'feelingLucky':
        cubit.loadFeelingLucky(title: title);
        return;
      case 'playlistSearch':
        cubit.loadPlaylistSearchPreset(query: value ?? '', title: title);
        return;
      default:
        if ((value ?? '').isNotEmpty) {
          cubit.onQueryChanged(value!);
        }
        return;
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 320) {
      return;
    }
    final cubit = context.read<SearchCubit>();
    cubit.loadMoreTracks();
    final state = cubit.state;
    if (state.currentMode == SearchPresetMode.text) {
      cubit.loadMoreUsers();
    }
    if (state.currentMode == SearchPresetMode.text ||
        state.currentMode == SearchPresetMode.playlistSearch) {
      cubit.loadMorePlaylists();
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 18.r,
          ),
        ),
        title: Text(
          AppStrings.searchInputTitle,
          style: AppTextStyles.titleBoldSmall,
        ),
      ),
      body: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          final error = state.paginationErrorMessage;
          if (error == null || error.isEmpty) {
            return;
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
          context.read<SearchCubit>().clearPaginationError();
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SearchInputField(
                  controller: _queryController,
                  onChanged: context.read<SearchCubit>().onQueryChanged,
                ),
                18.h.height,
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    if (state.currentMode == SearchPresetMode.text && state.query.length < 2) {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          AppStrings.searchMinCharsHint,
          style: AppTextStyles.textHint.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    if (state.isLoadingInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && !state.hasAnyResult) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: AppTextStyles.textHint.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            10.h.height,
            ElevatedButton(
              onPressed: () => context.read<SearchCubit>().retry(),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }

    if (!state.hasAnyResult) {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          AppStrings.searchNoResults,
          style: AppTextStyles.textHint.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (state.currentMode == SearchPresetMode.playlistSearch) ...[
          _SectionTitle(title: AppStrings.searchPlaylistsSection),
          _PlaylistResultsSliver(playlists: state.playlists),
          if (state.playlistsErrorMessage != null && state.playlists.isEmpty)
            _SectionError(text: state.playlistsErrorMessage!),
          if (state.hasMorePlaylists && state.isLoadingMore)
            const _LoadingSliver(),
        ] else ...[
          _SectionTitle(title: AppStrings.searchTracksSection),
          _TrackResultsSliver(tracks: state.tracks),
          if (state.tracksErrorMessage != null && state.tracks.isEmpty)
            _SectionError(text: state.tracksErrorMessage!),
          if (state.hasMoreTracks && state.isLoadingMore)
            const _LoadingSliver(),
        ],
        if (state.currentMode == SearchPresetMode.text) ...[
          _SectionTitle(title: AppStrings.searchArtistsSection),
          _UserResultsSliver(users: state.users),
          if (state.usersErrorMessage != null && state.users.isEmpty)
            _SectionError(text: state.usersErrorMessage!),
          if (state.hasMoreUsers && state.isLoadingMore) const _LoadingSliver(),
          _SectionTitle(title: AppStrings.searchPlaylistsSection),
          _PlaylistResultsSliver(playlists: state.playlists),
          if (state.playlistsErrorMessage != null && state.playlists.isEmpty)
            _SectionError(text: state.playlistsErrorMessage!),
          if (state.hasMorePlaylists && state.isLoadingMore)
            const _LoadingSliver(),
        ],
        SliverToBoxAdapter(child: 10.h.height),
      ],
    );
  }
}

class _SearchInputField extends StatelessWidget {
  const _SearchInputField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.textDark, size: 22.r),
          10.w.width,
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              onChanged: onChanged,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.searchInputPlaceholder,
                hintStyle: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textDark.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 6.h, bottom: 8.h),
        child: Text(title, style: AppTextStyles.titleBoldSmall),
      ),
    );
  }
}

class _TrackResultsSliver extends StatelessWidget {
  const _TrackResultsSliver({required this.tracks});

  final List<Track> tracks;

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.separated(
      itemCount: tracks.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final track = tracks[index];
        return _SearchItemTile(
          title: track.title,
          subtitle: track.artist,
          imageUrl: track.imageUrl,
          onTap: () {
            sl<PlayerBloc>().add(
              PlayTrackRequested(queue: tracks, index: index, autoPlay: true),
            );
            context.push(RouteNames.playerPage, extra: track);
          },
        );
      },
    );
  }
}

class _UserResultsSliver extends StatelessWidget {
  const _UserResultsSliver({required this.users});

  final List<SearchUser> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.separated(
      itemCount: users.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final user = users[index];
        return _SearchItemTile(
          title: user.name,
          subtitle: '@${user.handle}',
          imageUrl: user.imageUrl,
          trailing: user.isVerified
              ? Icon(
                  Icons.verified_rounded,
                  color: AppColors.primary,
                  size: 18.r,
                )
              : null,
          onTap: () => _showNotImplemented(context),
        );
      },
    );
  }
}

class _PlaylistResultsSliver extends StatelessWidget {
  const _PlaylistResultsSliver({required this.playlists});

  final List<SearchPlaylist> playlists;

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList.separated(
      itemCount: playlists.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return _SearchItemTile(
          title: playlist.name,
          subtitle: '${playlist.creatorName} - ${playlist.trackCount} tracks',
          imageUrl: playlist.imageUrl,
          onTap: () => _showNotImplemented(context),
        );
      },
    );
  }
}

void _showNotImplemented(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text(AppStrings.searchSectionNotImplemented)),
  );
}

class _SearchItemTile extends StatelessWidget {
  const _SearchItemTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textWhite.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: (imageUrl == null || imageUrl!.trim().isEmpty)
                    ? Image.asset(
                        Assets.images.logoApp.path,
                        width: 52.w,
                        height: 52.h,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: imageUrl!,
                        width: 52.w,
                        height: 52.h,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Image.asset(
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
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall,
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.textHint,
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          text,
          style: AppTextStyles.textHint.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _LoadingSliver extends StatelessWidget {
  const _LoadingSliver();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}
