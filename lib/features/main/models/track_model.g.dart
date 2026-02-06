// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackModel _$TrackModelFromJson(Map<String, dynamic> json) => _TrackModel(
  id: json['id'] as String,
  title: json['title'] as String,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  artwork: json['artwork'] == null
      ? null
      : ArtworkModel.fromJson(json['artwork'] as Map<String, dynamic>),
  duration: (json['duration'] as num?)?.toInt(),
);

Map<String, dynamic> _$TrackModelToJson(_TrackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'user': instance.user,
      'artwork': instance.artwork,
      'duration': instance.duration,
    };

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  handle: json['handle'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'handle': instance.handle,
    };

_ArtworkModel _$ArtworkModelFromJson(Map<String, dynamic> json) =>
    _ArtworkModel(
      x150: json['150x150'] as String?,
      x480: json['480x480'] as String?,
      x1000: json['1000x1000'] as String?,
    );

Map<String, dynamic> _$ArtworkModelToJson(_ArtworkModel instance) =>
    <String, dynamic>{
      '150x150': instance.x150,
      '480x480': instance.x480,
      '1000x1000': instance.x1000,
    };
