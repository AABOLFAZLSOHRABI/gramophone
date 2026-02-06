// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackModel {

 String get id; String get title; UserModel get user; ArtworkModel? get artwork; int? get duration;
/// Create a copy of TrackModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackModelCopyWith<TrackModel> get copyWith => _$TrackModelCopyWithImpl<TrackModel>(this as TrackModel, _$identity);

  /// Serializes this TrackModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.user, user) || other.user == user)&&(identical(other.artwork, artwork) || other.artwork == artwork)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,user,artwork,duration);

@override
String toString() {
  return 'TrackModel(id: $id, title: $title, user: $user, artwork: $artwork, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $TrackModelCopyWith<$Res>  {
  factory $TrackModelCopyWith(TrackModel value, $Res Function(TrackModel) _then) = _$TrackModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, UserModel user, ArtworkModel? artwork, int? duration
});


$UserModelCopyWith<$Res> get user;$ArtworkModelCopyWith<$Res>? get artwork;

}
/// @nodoc
class _$TrackModelCopyWithImpl<$Res>
    implements $TrackModelCopyWith<$Res> {
  _$TrackModelCopyWithImpl(this._self, this._then);

  final TrackModel _self;
  final $Res Function(TrackModel) _then;

/// Create a copy of TrackModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? user = null,Object? artwork = freezed,Object? duration = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,artwork: freezed == artwork ? _self.artwork : artwork // ignore: cast_nullable_to_non_nullable
as ArtworkModel?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of TrackModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of TrackModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArtworkModelCopyWith<$Res>? get artwork {
    if (_self.artwork == null) {
    return null;
  }

  return $ArtworkModelCopyWith<$Res>(_self.artwork!, (value) {
    return _then(_self.copyWith(artwork: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackModel].
extension TrackModelPatterns on TrackModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackModel value)  $default,){
final _that = this;
switch (_that) {
case _TrackModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrackModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  UserModel user,  ArtworkModel? artwork,  int? duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackModel() when $default != null:
return $default(_that.id,_that.title,_that.user,_that.artwork,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  UserModel user,  ArtworkModel? artwork,  int? duration)  $default,) {final _that = this;
switch (_that) {
case _TrackModel():
return $default(_that.id,_that.title,_that.user,_that.artwork,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  UserModel user,  ArtworkModel? artwork,  int? duration)?  $default,) {final _that = this;
switch (_that) {
case _TrackModel() when $default != null:
return $default(_that.id,_that.title,_that.user,_that.artwork,_that.duration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackModel implements TrackModel {
  const _TrackModel({required this.id, required this.title, required this.user, this.artwork, this.duration});
  factory _TrackModel.fromJson(Map<String, dynamic> json) => _$TrackModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  UserModel user;
@override final  ArtworkModel? artwork;
@override final  int? duration;

/// Create a copy of TrackModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackModelCopyWith<_TrackModel> get copyWith => __$TrackModelCopyWithImpl<_TrackModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.user, user) || other.user == user)&&(identical(other.artwork, artwork) || other.artwork == artwork)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,user,artwork,duration);

@override
String toString() {
  return 'TrackModel(id: $id, title: $title, user: $user, artwork: $artwork, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$TrackModelCopyWith<$Res> implements $TrackModelCopyWith<$Res> {
  factory _$TrackModelCopyWith(_TrackModel value, $Res Function(_TrackModel) _then) = __$TrackModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, UserModel user, ArtworkModel? artwork, int? duration
});


@override $UserModelCopyWith<$Res> get user;@override $ArtworkModelCopyWith<$Res>? get artwork;

}
/// @nodoc
class __$TrackModelCopyWithImpl<$Res>
    implements _$TrackModelCopyWith<$Res> {
  __$TrackModelCopyWithImpl(this._self, this._then);

  final _TrackModel _self;
  final $Res Function(_TrackModel) _then;

/// Create a copy of TrackModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? user = null,Object? artwork = freezed,Object? duration = freezed,}) {
  return _then(_TrackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,artwork: freezed == artwork ? _self.artwork : artwork // ignore: cast_nullable_to_non_nullable
as ArtworkModel?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of TrackModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of TrackModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArtworkModelCopyWith<$Res>? get artwork {
    if (_self.artwork == null) {
    return null;
  }

  return $ArtworkModelCopyWith<$Res>(_self.artwork!, (value) {
    return _then(_self.copyWith(artwork: value));
  });
}
}


/// @nodoc
mixin _$UserModel {

 String get id; String get name; String? get handle;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.handle, handle) || other.handle == handle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,handle);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, handle: $handle)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? handle
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? handle = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? handle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.name,_that.handle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? handle)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.name,_that.handle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? handle)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.name,_that.handle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, required this.name, this.handle});
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? handle;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.handle, handle) || other.handle == handle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,handle);

@override
String toString() {
  return 'UserModel(id: $id, name: $name, handle: $handle)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? handle
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? handle = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ArtworkModel {

@JsonKey(name: '150x150') String? get x150;@JsonKey(name: '480x480') String? get x480;@JsonKey(name: '1000x1000') String? get x1000;
/// Create a copy of ArtworkModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtworkModelCopyWith<ArtworkModel> get copyWith => _$ArtworkModelCopyWithImpl<ArtworkModel>(this as ArtworkModel, _$identity);

  /// Serializes this ArtworkModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtworkModel&&(identical(other.x150, x150) || other.x150 == x150)&&(identical(other.x480, x480) || other.x480 == x480)&&(identical(other.x1000, x1000) || other.x1000 == x1000));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x150,x480,x1000);

@override
String toString() {
  return 'ArtworkModel(x150: $x150, x480: $x480, x1000: $x1000)';
}


}

/// @nodoc
abstract mixin class $ArtworkModelCopyWith<$Res>  {
  factory $ArtworkModelCopyWith(ArtworkModel value, $Res Function(ArtworkModel) _then) = _$ArtworkModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '150x150') String? x150,@JsonKey(name: '480x480') String? x480,@JsonKey(name: '1000x1000') String? x1000
});




}
/// @nodoc
class _$ArtworkModelCopyWithImpl<$Res>
    implements $ArtworkModelCopyWith<$Res> {
  _$ArtworkModelCopyWithImpl(this._self, this._then);

  final ArtworkModel _self;
  final $Res Function(ArtworkModel) _then;

/// Create a copy of ArtworkModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x150 = freezed,Object? x480 = freezed,Object? x1000 = freezed,}) {
  return _then(_self.copyWith(
x150: freezed == x150 ? _self.x150 : x150 // ignore: cast_nullable_to_non_nullable
as String?,x480: freezed == x480 ? _self.x480 : x480 // ignore: cast_nullable_to_non_nullable
as String?,x1000: freezed == x1000 ? _self.x1000 : x1000 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtworkModel].
extension ArtworkModelPatterns on ArtworkModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtworkModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtworkModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtworkModel value)  $default,){
final _that = this;
switch (_that) {
case _ArtworkModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtworkModel value)?  $default,){
final _that = this;
switch (_that) {
case _ArtworkModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '150x150')  String? x150, @JsonKey(name: '480x480')  String? x480, @JsonKey(name: '1000x1000')  String? x1000)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtworkModel() when $default != null:
return $default(_that.x150,_that.x480,_that.x1000);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '150x150')  String? x150, @JsonKey(name: '480x480')  String? x480, @JsonKey(name: '1000x1000')  String? x1000)  $default,) {final _that = this;
switch (_that) {
case _ArtworkModel():
return $default(_that.x150,_that.x480,_that.x1000);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '150x150')  String? x150, @JsonKey(name: '480x480')  String? x480, @JsonKey(name: '1000x1000')  String? x1000)?  $default,) {final _that = this;
switch (_that) {
case _ArtworkModel() when $default != null:
return $default(_that.x150,_that.x480,_that.x1000);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArtworkModel implements ArtworkModel {
  const _ArtworkModel({@JsonKey(name: '150x150') this.x150, @JsonKey(name: '480x480') this.x480, @JsonKey(name: '1000x1000') this.x1000});
  factory _ArtworkModel.fromJson(Map<String, dynamic> json) => _$ArtworkModelFromJson(json);

@override@JsonKey(name: '150x150') final  String? x150;
@override@JsonKey(name: '480x480') final  String? x480;
@override@JsonKey(name: '1000x1000') final  String? x1000;

/// Create a copy of ArtworkModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtworkModelCopyWith<_ArtworkModel> get copyWith => __$ArtworkModelCopyWithImpl<_ArtworkModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtworkModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtworkModel&&(identical(other.x150, x150) || other.x150 == x150)&&(identical(other.x480, x480) || other.x480 == x480)&&(identical(other.x1000, x1000) || other.x1000 == x1000));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x150,x480,x1000);

@override
String toString() {
  return 'ArtworkModel(x150: $x150, x480: $x480, x1000: $x1000)';
}


}

/// @nodoc
abstract mixin class _$ArtworkModelCopyWith<$Res> implements $ArtworkModelCopyWith<$Res> {
  factory _$ArtworkModelCopyWith(_ArtworkModel value, $Res Function(_ArtworkModel) _then) = __$ArtworkModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '150x150') String? x150,@JsonKey(name: '480x480') String? x480,@JsonKey(name: '1000x1000') String? x1000
});




}
/// @nodoc
class __$ArtworkModelCopyWithImpl<$Res>
    implements _$ArtworkModelCopyWith<$Res> {
  __$ArtworkModelCopyWithImpl(this._self, this._then);

  final _ArtworkModel _self;
  final $Res Function(_ArtworkModel) _then;

/// Create a copy of ArtworkModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x150 = freezed,Object? x480 = freezed,Object? x1000 = freezed,}) {
  return _then(_ArtworkModel(
x150: freezed == x150 ? _self.x150 : x150 // ignore: cast_nullable_to_non_nullable
as String?,x480: freezed == x480 ? _self.x480 : x480 // ignore: cast_nullable_to_non_nullable
as String?,x1000: freezed == x1000 ? _self.x1000 : x1000 // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
