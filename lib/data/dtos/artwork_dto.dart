import 'package:freezed_annotation/freezed_annotation.dart';

part 'artwork_dto.freezed.dart';
part 'artwork_dto.g.dart';

@freezed
abstract class ArtworkDto with _$ArtworkDto {
  const factory ArtworkDto({@JsonKey(name: '1000x1000') String? x1000}) =
      _ArtworkDto;

  factory ArtworkDto.fromJson(Map<String, dynamic> json) =>
      _$ArtworkDtoFromJson(json);
}
