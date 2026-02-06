import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_model.freezed.dart';
part 'track_model.g.dart';

@freezed
abstract class TrackModel with _$TrackModel {
  const factory TrackModel({
    required String id,
    required String title,
    required UserModel user,
    ArtworkModel? artwork,
    int? duration,
  }) = _TrackModel;

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);
}

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    String? handle,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
abstract class ArtworkModel with _$ArtworkModel {
  const factory ArtworkModel({
    @JsonKey(name: '150x150') String? x150,
    @JsonKey(name: '480x480') String? x480,
    @JsonKey(name: '1000x1000') String? x1000,
  }) = _ArtworkModel;

  factory ArtworkModel.fromJson(Map<String, dynamic> json) =>
      _$ArtworkModelFromJson(json);
}
