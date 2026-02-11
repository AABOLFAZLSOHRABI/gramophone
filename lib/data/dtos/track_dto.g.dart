// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackDto _$TrackDtoFromJson(Map<String, dynamic> json) => _TrackDto(
  id: json['id'] as String,
  title: json['title'] as String,
  artist: json['artist'] as String,
  artistHandle: json['artistHandle'] as String? ?? '',
  artwork: json['artwork'] == null
      ? null
      : ArtworkDto.fromJson(json['artwork'] as Map<String, dynamic>),
  duration: (json['duration'] as num?)?.toInt() ?? 0,
  streamUrl: json['streamUrl'] as String,
  tags: json['tags'] as String? ?? '',
  genre: json['genre'] as String? ?? '',
  mood: json['mood'] as String? ?? '',
  isDownloadable: json['isDownloadable'] as bool? ?? false,
);

Map<String, dynamic> _$TrackDtoToJson(_TrackDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'artist': instance.artist,
  'artistHandle': instance.artistHandle,
  'artwork': instance.artwork,
  'duration': instance.duration,
  'streamUrl': instance.streamUrl,
  'tags': instance.tags,
  'genre': instance.genre,
  'mood': instance.mood,
  'isDownloadable': instance.isDownloadable,
};
