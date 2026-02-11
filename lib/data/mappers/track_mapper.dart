import '../../domain/entities/track.dart';
import '../dtos/track_dto.dart';

extension TrackDtoMapper on TrackDto {
  Track toEntity({required String apiBaseUrl}) {
    final image = artwork?.x1000;
    final stream = '$apiBaseUrl/tracks/$id/stream';

    return Track(
      id: id,
      title: title,
      artist: artist,
      artistHandle: artistHandle.isEmpty ? null : artistHandle,
      imageUrl: image,
      duration: duration == 0 ? null : duration,
      streamUrl: stream,
      tags: tags.isEmpty ? null : tags,
      genre: genre.isEmpty ? null : genre,
      mood: mood.isEmpty ? null : mood,
      isDownloadable: isDownloadable,
    );
  }
}
