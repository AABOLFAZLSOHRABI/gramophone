import '../../core/network/endpoints.dart';
import '../../domain/entities/review_item.dart';
import '../dtos/playlist_dto.dart';
import 'track_mapper.dart';

extension PlaylistDtoMapper on PlaylistDto {
  ReviewItem toReviewItem() {
    final subtitleText = (description != null && description!.isNotEmpty)
        ? description!
        : creatorName;
    final playlistTracks = tracks
        .map(
          (trackDto) => trackDto.toEntity(apiBaseUrl: Endpoints.audiusBaseUrl),
        )
        .toList();
    final firstTrackImage = playlistTracks.isNotEmpty
        ? playlistTracks.first.imageUrl
        : null;

    return ReviewItem(
      id: id,
      title: name,
      subtitle: subtitleText,
      imageUrl: firstTrackImage ?? artwork1000 ?? artwork480 ?? artwork150,
      tracks: playlistTracks,
    );
  }
}
