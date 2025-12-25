// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reveal_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RevealTokenModel {

 String get id; String get participantId; String get matchId; String get token; DateTime get expiresAt; bool get isRevealed; DateTime? get revealedAt;
/// Create a copy of RevealTokenModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevealTokenModelCopyWith<RevealTokenModel> get copyWith => _$RevealTokenModelCopyWithImpl<RevealTokenModel>(this as RevealTokenModel, _$identity);

  /// Serializes this RevealTokenModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevealTokenModel&&(identical(other.id, id) || other.id == id)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isRevealed, isRevealed) || other.isRevealed == isRevealed)&&(identical(other.revealedAt, revealedAt) || other.revealedAt == revealedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participantId,matchId,token,expiresAt,isRevealed,revealedAt);

@override
String toString() {
  return 'RevealTokenModel(id: $id, participantId: $participantId, matchId: $matchId, token: $token, expiresAt: $expiresAt, isRevealed: $isRevealed, revealedAt: $revealedAt)';
}


}

/// @nodoc
abstract mixin class $RevealTokenModelCopyWith<$Res>  {
  factory $RevealTokenModelCopyWith(RevealTokenModel value, $Res Function(RevealTokenModel) _then) = _$RevealTokenModelCopyWithImpl;
@useResult
$Res call({
 String id, String participantId, String matchId, String token, DateTime expiresAt, bool isRevealed, DateTime? revealedAt
});




}
/// @nodoc
class _$RevealTokenModelCopyWithImpl<$Res>
    implements $RevealTokenModelCopyWith<$Res> {
  _$RevealTokenModelCopyWithImpl(this._self, this._then);

  final RevealTokenModel _self;
  final $Res Function(RevealTokenModel) _then;

/// Create a copy of RevealTokenModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? participantId = null,Object? matchId = null,Object? token = null,Object? expiresAt = null,Object? isRevealed = null,Object? revealedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,isRevealed: null == isRevealed ? _self.isRevealed : isRevealed // ignore: cast_nullable_to_non_nullable
as bool,revealedAt: freezed == revealedAt ? _self.revealedAt : revealedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RevealTokenModel].
extension RevealTokenModelPatterns on RevealTokenModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevealTokenModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevealTokenModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevealTokenModel value)  $default,){
final _that = this;
switch (_that) {
case _RevealTokenModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevealTokenModel value)?  $default,){
final _that = this;
switch (_that) {
case _RevealTokenModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String participantId,  String matchId,  String token,  DateTime expiresAt,  bool isRevealed,  DateTime? revealedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevealTokenModel() when $default != null:
return $default(_that.id,_that.participantId,_that.matchId,_that.token,_that.expiresAt,_that.isRevealed,_that.revealedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String participantId,  String matchId,  String token,  DateTime expiresAt,  bool isRevealed,  DateTime? revealedAt)  $default,) {final _that = this;
switch (_that) {
case _RevealTokenModel():
return $default(_that.id,_that.participantId,_that.matchId,_that.token,_that.expiresAt,_that.isRevealed,_that.revealedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String participantId,  String matchId,  String token,  DateTime expiresAt,  bool isRevealed,  DateTime? revealedAt)?  $default,) {final _that = this;
switch (_that) {
case _RevealTokenModel() when $default != null:
return $default(_that.id,_that.participantId,_that.matchId,_that.token,_that.expiresAt,_that.isRevealed,_that.revealedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RevealTokenModel implements RevealTokenModel {
  const _RevealTokenModel({required this.id, required this.participantId, required this.matchId, required this.token, required this.expiresAt, this.isRevealed = false, this.revealedAt});
  factory _RevealTokenModel.fromJson(Map<String, dynamic> json) => _$RevealTokenModelFromJson(json);

@override final  String id;
@override final  String participantId;
@override final  String matchId;
@override final  String token;
@override final  DateTime expiresAt;
@override@JsonKey() final  bool isRevealed;
@override final  DateTime? revealedAt;

/// Create a copy of RevealTokenModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevealTokenModelCopyWith<_RevealTokenModel> get copyWith => __$RevealTokenModelCopyWithImpl<_RevealTokenModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevealTokenModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevealTokenModel&&(identical(other.id, id) || other.id == id)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.token, token) || other.token == token)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isRevealed, isRevealed) || other.isRevealed == isRevealed)&&(identical(other.revealedAt, revealedAt) || other.revealedAt == revealedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participantId,matchId,token,expiresAt,isRevealed,revealedAt);

@override
String toString() {
  return 'RevealTokenModel(id: $id, participantId: $participantId, matchId: $matchId, token: $token, expiresAt: $expiresAt, isRevealed: $isRevealed, revealedAt: $revealedAt)';
}


}

/// @nodoc
abstract mixin class _$RevealTokenModelCopyWith<$Res> implements $RevealTokenModelCopyWith<$Res> {
  factory _$RevealTokenModelCopyWith(_RevealTokenModel value, $Res Function(_RevealTokenModel) _then) = __$RevealTokenModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String participantId, String matchId, String token, DateTime expiresAt, bool isRevealed, DateTime? revealedAt
});




}
/// @nodoc
class __$RevealTokenModelCopyWithImpl<$Res>
    implements _$RevealTokenModelCopyWith<$Res> {
  __$RevealTokenModelCopyWithImpl(this._self, this._then);

  final _RevealTokenModel _self;
  final $Res Function(_RevealTokenModel) _then;

/// Create a copy of RevealTokenModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? participantId = null,Object? matchId = null,Object? token = null,Object? expiresAt = null,Object? isRevealed = null,Object? revealedAt = freezed,}) {
  return _then(_RevealTokenModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,isRevealed: null == isRevealed ? _self.isRevealed : isRevealed // ignore: cast_nullable_to_non_nullable
as bool,revealedAt: freezed == revealedAt ? _self.revealedAt : revealedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
