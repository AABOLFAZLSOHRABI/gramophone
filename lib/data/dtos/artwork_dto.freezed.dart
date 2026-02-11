// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artwork_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArtworkDto {

@JsonKey(name: '1000x1000') String? get x1000;
/// Create a copy of ArtworkDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtworkDtoCopyWith<ArtworkDto> get copyWith => _$ArtworkDtoCopyWithImpl<ArtworkDto>(this as ArtworkDto, _$identity);

  /// Serializes this ArtworkDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtworkDto&&(identical(other.x1000, x1000) || other.x1000 == x1000));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x1000);

@override
String toString() {
  return 'ArtworkDto(x1000: $x1000)';
}


}

/// @nodoc
abstract mixin class $ArtworkDtoCopyWith<$Res>  {
  factory $ArtworkDtoCopyWith(ArtworkDto value, $Res Function(ArtworkDto) _then) = _$ArtworkDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '1000x1000') String? x1000
});




}
/// @nodoc
class _$ArtworkDtoCopyWithImpl<$Res>
    implements $ArtworkDtoCopyWith<$Res> {
  _$ArtworkDtoCopyWithImpl(this._self, this._then);

  final ArtworkDto _self;
  final $Res Function(ArtworkDto) _then;

/// Create a copy of ArtworkDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x1000 = freezed,}) {
  return _then(_self.copyWith(
x1000: freezed == x1000 ? _self.x1000 : x1000 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtworkDto].
extension ArtworkDtoPatterns on ArtworkDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtworkDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtworkDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtworkDto value)  $default,){
final _that = this;
switch (_that) {
case _ArtworkDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtworkDto value)?  $default,){
final _that = this;
switch (_that) {
case _ArtworkDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '1000x1000')  String? x1000)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtworkDto() when $default != null:
return $default(_that.x1000);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '1000x1000')  String? x1000)  $default,) {final _that = this;
switch (_that) {
case _ArtworkDto():
return $default(_that.x1000);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '1000x1000')  String? x1000)?  $default,) {final _that = this;
switch (_that) {
case _ArtworkDto() when $default != null:
return $default(_that.x1000);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArtworkDto implements ArtworkDto {
  const _ArtworkDto({@JsonKey(name: '1000x1000') this.x1000});
  factory _ArtworkDto.fromJson(Map<String, dynamic> json) => _$ArtworkDtoFromJson(json);

@override@JsonKey(name: '1000x1000') final  String? x1000;

/// Create a copy of ArtworkDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtworkDtoCopyWith<_ArtworkDto> get copyWith => __$ArtworkDtoCopyWithImpl<_ArtworkDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtworkDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtworkDto&&(identical(other.x1000, x1000) || other.x1000 == x1000));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x1000);

@override
String toString() {
  return 'ArtworkDto(x1000: $x1000)';
}


}

/// @nodoc
abstract mixin class _$ArtworkDtoCopyWith<$Res> implements $ArtworkDtoCopyWith<$Res> {
  factory _$ArtworkDtoCopyWith(_ArtworkDto value, $Res Function(_ArtworkDto) _then) = __$ArtworkDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '1000x1000') String? x1000
});




}
/// @nodoc
class __$ArtworkDtoCopyWithImpl<$Res>
    implements _$ArtworkDtoCopyWith<$Res> {
  __$ArtworkDtoCopyWithImpl(this._self, this._then);

  final _ArtworkDto _self;
  final $Res Function(_ArtworkDto) _then;

/// Create a copy of ArtworkDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x1000 = freezed,}) {
  return _then(_ArtworkDto(
x1000: freezed == x1000 ? _self.x1000 : x1000 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
