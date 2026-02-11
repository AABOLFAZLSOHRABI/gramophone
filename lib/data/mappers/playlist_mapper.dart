import '../../domain/entities/review_item.dart';
import '../dtos/playlist_dto.dart';

extension PlaylistDtoMapper on PlaylistDto {
  ReviewItem toReviewItem() {
    final subtitleText =
        (description != null && description!.isNotEmpty)
            ? description!
            : creatorName;

    return ReviewItem(
      id: id,
      title: name,
      subtitle: subtitleText,
      imageUrl: artwork1000 ?? artwork480 ?? artwork150,
    );
  }
}
