import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gramophone/core/di/service_locator.dart';
import 'package:gramophone/core/result/result.dart';
import 'package:gramophone/core/router/route_names.dart';
import 'package:gramophone/core/ui/l10n/app_strings.dart';
import 'package:gramophone/core/ui/theme/app_text_styles.dart';
import 'package:gramophone/core/ui/widgets/media_item_card.dart';
import 'package:gramophone/core/utils/extensions/size_box_extensions.dart';
import 'package:gramophone/domain/entities/track.dart';
import 'package:gramophone/features/main/domain/repositories/main_repository.dart';
import 'package:gramophone/features/player/presentation/bloc/player_bloc.dart';
import 'package:gramophone/features/player/presentation/bloc/player_event.dart';

class LibraryTabPage extends StatelessWidget {
  const LibraryTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<Result<List<Track>>>(
          stream: sl<MainRepository>().watchOfflineTracks(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final state = snapshot.data!;
            switch (state) {
              case ResultSuccess<List<Track>>():
                if (state.data.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.noOfflineTracks,
                      style: AppTextStyles.textHint,
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 16.h,
                  ),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    final track = state.data[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: SizedBox(
                        height: 78.h,
                        child: Row(
                          children: [
                            MediaItemCard(
                              title: track.title,
                              subtitle: track.artist,
                              imageUrl: track.imageUrl,
                              imageWidth: 78.w,
                              imageHeight: 78.h,
                              onTap: () {
                                sl<PlayerBloc>().add(
                                  LoadQueueAndTrack(
                                    queue: state.data,
                                    startIndex: index,
                                  ),
                                );
                                context.push(
                                  RouteNames.playerPage,
                                  extra: track,
                                );
                              },
                            ),
                            12.w.width,
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  sl<PlayerBloc>().add(
                                    LoadQueueAndTrack(
                                      queue: state.data,
                                      startIndex: index,
                                    ),
                                  );
                                  context.push(
                                    RouteNames.playerPage,
                                    extra: track,
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      track.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.titleMedium,
                                    ),
                                    4.h.height,
                                    Text(
                                      track.artist,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.textHint,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              case ResultFailure<List<Track>>():
                return Center(
                  child: Text(
                    state.failure.message,
                    style: AppTextStyles.textHint,
                    textAlign: TextAlign.center,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
