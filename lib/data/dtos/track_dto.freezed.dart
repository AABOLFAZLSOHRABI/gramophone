// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackDto {

 String get id; String get title; String get artist; String get artistHandle; ArtworkDto? get artwork; int get duration;@JsonKey(name: 'streamUrl') String get streamUrl; String get tags; String get genre; String get mood; bool get isDownloadable;
/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackDtoCopyWith<TrackDto> get copyWith => _$TrackDtoCopyWithImpl<TrackDto>(this as TrackDto, _$identity);

  /// Serializes this TrackDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.artistHandle, artistHandle) || other.artistHandle == artistHandle)&&(identical(other.artwork, artwork) || other.artwork == artwork)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isDownloadable, isDownloadable) || other.isDownloadable == isDownloadable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,artist,artistHandle,artwork,duration,streamUrl,tags,genre,mood,isDownloadable);

@override
String toString() {
  return 'TrackDto(id: $id, title: $title, artist: $artist, artistHandle: $artistHandle, artwork: $artwork, duration: $duration, streamUrl: $streamUrl, tags: $tags, genre: $genre, mood: $mood, isDownloadable: $isDownloadable)';
}


}

/// @nodoc
abstract mixin class $TrackDtoCopyWith<$Res>  {
  factory $TrackDtoCopyWith(TrackDto value, $Res Function(TrackDto) _then) = _$TrackDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String artist, String artistHandle, ArtworkDto? artwork, int duration,@JsonKey(name: 'streamUrl') String streamUrl, String tags, String genre, String mood, bool isDownloadable
});


$ArtworkDtoCopyWith<$Res>? get artwork;

}
/// @nodoc
class _$TrackDtoCopyWithImpl<$Res>
    implements $TrackDtoCopyWith<$Res> {
  _$TrackDtoCopyWithImpl(this._self, this._then);

  final TrackDto _self;
  final $Res Function(TrackDto) _then;

/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? artistHandle = null,Object? artwork = freezed,Object? duration = null,Object? streamUrl = null,Object? tags = null,Object? genre = null,Object? mood = null,Object? isDownloadable = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,artistHandle: null == artistHandle ? _self.artistHandle : artistHandle // ignore: cast_nullable_to_non_nullable
as String,artwork: freezed == artwork ? _self.artwork : artwork // ignore: cast_nullable_to_non_nullable
as ArtworkDto?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,streamUrl: null == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,isDownloadable: null == isDownloadable ? _self.isDownloadable : isDownloadable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArtworkDtoCopyWith<$Res>? get artwork {
    if (_self.artwork == null) {
    return null;
  }

  return $ArtworkDtoCopyWith<$Res>(_self.artwork!, (value) {
    return _then(_self.copyWith(artwork: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackDto].
extension TrackDtoPatterns on TrackDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackDto value)  $default,){
final _that = this;
switch (_that) {
case _TrackDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackDto value)?  $default,){
final _that = this;
switch (_that) {
case _TrackDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String artist,  String artistHandle,  ArtworkDto? artwork,  int duration, @JsonKey(name: 'streamUrl')  String streamUrl,  String tags,  String genre,  String mood,  bool isDownloadable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackDto() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.artistHandle,_that.artwork,_that.duration,_that.streamUrl,_that.tags,_that.genre,_that.mood,_that.isDownloadable);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String artist,  String artistHandle,  ArtworkDto? artwork,  int duration, @JsonKey(name: 'streamUrl')  String streamUrl,  String tags,  String genre,  String mood,  bool isDownloadable)  $default,) {final _that = this;
switch (_that) {
case _TrackDto():
return $default(_that.id,_that.title,_that.artist,_that.artistHandle,_that.artwork,_that.duration,_that.streamUrl,_that.tags,_that.genre,_that.mood,_that.isDownloadable);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String artist,  String artistHandle,  ArtworkDto? artwork,  int duration, @JsonKey(name: 'streamUrl')  String streamUrl,  String tags,  String genre,  String mood,  bool isDownloadable)?  $default,) {final _that = this;
switch (_that) {
case _TrackDto() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.artistHandle,_that.artwork,_that.duration,_that.streamUrl,_that.tags,_that.genre,_that.mood,_that.isDownloadable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackDto implements TrackDto {
  const _TrackDto({required this.id, required this.title, required this.artist, this.artistHandle = '', this.artwork, this.duration = 0, @JsonKey(name: 'streamUrl') required this.streamUrl, this.tags = '', this.genre = '', this.mood = '', this.isDownloadable = false});
  factory _TrackDto.fromJson(Map<String, dynamic> json) => _$TrackDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  String artist;
@override@JsonKey() final  String artistHandle;
@override final  ArtworkDto? artwork;
@override@JsonKey() final  int duration;
@override@JsonKey(name: 'streamUrl') final  String streamUrl;
@override@JsonKey() final  String tags;
@override@JsonKey() final  String genre;
@override@JsonKey() final  String mood;
@override@JsonKey() final  bool isDownloadable;

/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackDtoCopyWith<_TrackDto> get copyWith => __$TrackDtoCopyWithImpl<_TrackDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.artistHandle, artistHandle) || other.artistHandle == artistHandle)&&(identical(other.artwork, artwork) || other.artwork == artwork)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.tags, tags) || other.tags == tags)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.isDownloadable, isDownloadable) || other.isDownloadable == isDownloadable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,artist,artistHandle,artwork,duration,streamUrl,tags,genre,mood,isDownloadable);

@override
String toString() {
  return 'TrackDto(id: $id, title: $title, artist: $artist, artistHandle: $artistHandle, artwork: $artwork, duration: $duration, streamUrl: $streamUrl, tags: $tags, genre: $genre, mood: $mood, isDownloadable: $isDownloadable)';
}


}

/// @nodoc
abstract mixin class _$TrackDtoCopyWith<$Res> implements $TrackDtoCopyWith<$Res> {
  factory _$TrackDtoCopyWith(_TrackDto value, $Res Function(_TrackDto) _then) = __$TrackDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String artist, String artistHandle, ArtworkDto? artwork, int duration,@JsonKey(name: 'streamUrl') String streamUrl, String tags, String genre, String mood, bool isDownloadable
});


@override $ArtworkDtoCopyWith<$Res>? get artwork;

}
/// @nodoc
class __$TrackDtoCopyWithImpl<$Res>
    implements _$TrackDtoCopyWith<$Res> {
  __$TrackDtoCopyWithImpl(this._self, this._then);

  final _TrackDto _self;
  final $Res Function(_TrackDto) _then;

/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? artistHandle = null,Object? artwork = freezed,Object? duration = null,Object? streamUrl = null,Object? tags = null,Object? genre = null,Object? mood = null,Object? isDownloadable = null,}) {
  return _then(_TrackDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,artistHandle: null == artistHandle ? _self.artistHandle : artistHandle // ignore: cast_nullable_to_non_nullable
as String,artwork: freezed == artwork ? _self.artwork : artwork // ignore: cast_nullable_to_non_nullable
as ArtworkDto?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,streamUrl: null == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as String,isDownloadable: null == isDownloadable ? _self.isDownloadable : isDownloadable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TrackDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArtworkDtoCopyWith<$Res>? get artwork {
    if (_self.artwork == null) {
    return null;
  }

  return $ArtworkDtoCopyWith<$Res>(_self.artwork!, (value) {
    return _then(_self.copyWith(artwork: value));
  });
}
}

// dart format on
