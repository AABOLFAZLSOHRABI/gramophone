import '../../../../domain/entities/review_item.dart';
import '../../../../domain/entities/track.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.recentlyPlayed,
    required this.editorsPicks,
    required this.reviewItems,
    this.recentlyError,
    this.editorsError,
    this.reviewError,
  });

  final List<Track> recentlyPlayed;
  final List<Track> editorsPicks;
  final List<ReviewItem> reviewItems;
  final String? recentlyError;
  final String? editorsError;
  final String? reviewError;
}

final class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;
}
