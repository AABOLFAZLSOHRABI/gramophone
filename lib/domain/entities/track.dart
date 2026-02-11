import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';

@freezed
abstract class Track with _$Track {
  const factory Track({
    required String id,
    required String title,
    required String artist,

    String? artistHandle,
    String? imageUrl,

    int? duration,
    String? streamUrl,

    String? tags,
    String? genre,
    String? mood,

    bool? isDownloadable,
  }) = _Track;
}
