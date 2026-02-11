import 'package:freezed_annotation/freezed_annotation.dart';
import 'artwork_dto.dart';

part 'track_dto.freezed.dart';
part 'track_dto.g.dart';

@freezed
abstract class TrackDto with _$TrackDto {
  const factory TrackDto({
    required String id,
    required String title,
    required String artist,
    @Default('') String artistHandle,

    ArtworkDto? artwork,
    @Default(0) int duration,

    @JsonKey(name: 'streamUrl') required String streamUrl,

    @Default('') String tags,
    @Default('') String genre,
    @Default('') String mood,

    @Default(false) bool isDownloadable,
  }) = _TrackDto;

  factory TrackDto.fromJson(Map<String, dynamic> json) =>
      _$TrackDtoFromJson(json);
}
