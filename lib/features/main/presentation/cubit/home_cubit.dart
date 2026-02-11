import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/result.dart';
import '../../../../core/ui/l10n/app_strings.dart';
import '../../../../domain/entities/review_item.dart';
import '../../../../domain/entities/track.dart';
import '../../domain/repositories/main_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeInitial());

  final MainRepository _repository;

  Future<void> loadHome() async {
    emit(const HomeLoading());

    final recentlyResult = await _repository.getTrendingTracksFromApi(
      time: 'allTime',
      limit: 10,
      offset: 0,
    );
    final editorsResult = await _repository.getTrendingTracksFromApi(
      time: 'week',
      limit: 10,
      offset: 0,
    );
    final reviewResult = await _repository.getReviewItemsFromApi(
      time: 'week',
      limit: 6,
      offset: 0,
    );

    final recentlyTracks = <Track>[];
    final editorsTracks = <Track>[];
    final reviewItems = <ReviewItem>[];
    String? recentlyError;
    String? editorsError;
    String? reviewError;

    switch (recentlyResult) {
      case ResultSuccess():
        recentlyTracks.addAll(recentlyResult.data);
      case ResultFailure():
        recentlyError = recentlyResult.failure.message;
    }

    switch (editorsResult) {
      case ResultSuccess():
        editorsTracks.addAll(editorsResult.data);
      case ResultFailure():
        editorsError = editorsResult.failure.message;
    }

    switch (reviewResult) {
      case ResultSuccess():
        reviewItems.addAll(reviewResult.data);
      case ResultFailure():
        reviewError = reviewResult.failure.message;
    }

    if (recentlyTracks.isEmpty && editorsTracks.isEmpty && reviewItems.isEmpty) {
      final fallback =
          recentlyError ?? editorsError ?? reviewError ?? AppStrings.somethingWentWrong;
      emit(HomeError(fallback));
      return;
    }

    emit(
      HomeLoaded(
        recentlyPlayed: List<Track>.from(recentlyTracks),
        editorsPicks: List<Track>.from(editorsTracks),
        reviewItems: List<ReviewItem>.from(reviewItems),
        recentlyError: recentlyError,
        editorsError: editorsError,
        reviewError: reviewError,
      ),
    );
  }
}
