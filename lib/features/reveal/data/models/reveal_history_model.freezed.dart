// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reveal_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RevealHistoryModel {

 String get id; String get participantId; String get participantName; String get matchId; String get receiverId; String get receiverName; DateTime get revealedAt; String get eventId;
/// Create a copy of RevealHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevealHistoryModelCopyWith<RevealHistoryModel> get copyWith => _$RevealHistoryModelCopyWithImpl<RevealHistoryModel>(this as RevealHistoryModel, _$identity);

  /// Serializes this RevealHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevealHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.participantName, participantName) || other.participantName == participantName)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.revealedAt, revealedAt) || other.revealedAt == revealedAt)&&(identical(other.eventId, eventId) || other.eventId == eventId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participantId,participantName,matchId,receiverId,receiverName,revealedAt,eventId);

@override
String toString() {
  return 'RevealHistoryModel(id: $id, participantId: $participantId, participantName: $participantName, matchId: $matchId, receiverId: $receiverId, receiverName: $receiverName, revealedAt: $revealedAt, eventId: $eventId)';
}


}

/// @nodoc
abstract mixin class $RevealHistoryModelCopyWith<$Res>  {
  factory $RevealHistoryModelCopyWith(RevealHistoryModel value, $Res Function(RevealHistoryModel) _then) = _$RevealHistoryModelCopyWithImpl;
@useResult
$Res call({
 String id, String participantId, String participantName, String matchId, String receiverId, String receiverName, DateTime revealedAt, String eventId
});




}
/// @nodoc
class _$RevealHistoryModelCopyWithImpl<$Res>
    implements $RevealHistoryModelCopyWith<$Res> {
  _$RevealHistoryModelCopyWithImpl(this._self, this._then);

  final RevealHistoryModel _self;
  final $Res Function(RevealHistoryModel) _then;

/// Create a copy of RevealHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? participantId = null,Object? participantName = null,Object? matchId = null,Object? receiverId = null,Object? receiverName = null,Object? revealedAt = null,Object? eventId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,participantName: null == participantName ? _self.participantName : participantName // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,receiverId: null == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String,receiverName: null == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String,revealedAt: null == revealedAt ? _self.revealedAt : revealedAt // ignore: cast_nullable_to_non_nullable
as DateTime,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RevealHistoryModel].
extension RevealHistoryModelPatterns on RevealHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevealHistoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevealHistoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevealHistoryModel value)  $default,){
final _that = this;
switch (_that) {
case _RevealHistoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevealHistoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _RevealHistoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String participantId,  String participantName,  String matchId,  String receiverId,  String receiverName,  DateTime revealedAt,  String eventId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevealHistoryModel() when $default != null:
return $default(_that.id,_that.participantId,_that.participantName,_that.matchId,_that.receiverId,_that.receiverName,_that.revealedAt,_that.eventId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String participantId,  String participantName,  String matchId,  String receiverId,  String receiverName,  DateTime revealedAt,  String eventId)  $default,) {final _that = this;
switch (_that) {
case _RevealHistoryModel():
return $default(_that.id,_that.participantId,_that.participantName,_that.matchId,_that.receiverId,_that.receiverName,_that.revealedAt,_that.eventId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String participantId,  String participantName,  String matchId,  String receiverId,  String receiverName,  DateTime revealedAt,  String eventId)?  $default,) {final _that = this;
switch (_that) {
case _RevealHistoryModel() when $default != null:
return $default(_that.id,_that.participantId,_that.participantName,_that.matchId,_that.receiverId,_that.receiverName,_that.revealedAt,_that.eventId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RevealHistoryModel implements RevealHistoryModel {
  const _RevealHistoryModel({required this.id, required this.participantId, required this.participantName, required this.matchId, required this.receiverId, required this.receiverName, required this.revealedAt, required this.eventId});
  factory _RevealHistoryModel.fromJson(Map<String, dynamic> json) => _$RevealHistoryModelFromJson(json);

@override final  String id;
@override final  String participantId;
@override final  String participantName;
@override final  String matchId;
@override final  String receiverId;
@override final  String receiverName;
@override final  DateTime revealedAt;
@override final  String eventId;

/// Create a copy of RevealHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevealHistoryModelCopyWith<_RevealHistoryModel> get copyWith => __$RevealHistoryModelCopyWithImpl<_RevealHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevealHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevealHistoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.participantName, participantName) || other.participantName == participantName)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.receiverId, receiverId) || other.receiverId == receiverId)&&(identical(other.receiverName, receiverName) || other.receiverName == receiverName)&&(identical(other.revealedAt, revealedAt) || other.revealedAt == revealedAt)&&(identical(other.eventId, eventId) || other.eventId == eventId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,participantId,participantName,matchId,receiverId,receiverName,revealedAt,eventId);

@override
String toString() {
  return 'RevealHistoryModel(id: $id, participantId: $participantId, participantName: $participantName, matchId: $matchId, receiverId: $receiverId, receiverName: $receiverName, revealedAt: $revealedAt, eventId: $eventId)';
}


}

/// @nodoc
abstract mixin class _$RevealHistoryModelCopyWith<$Res> implements $RevealHistoryModelCopyWith<$Res> {
  factory _$RevealHistoryModelCopyWith(_RevealHistoryModel value, $Res Function(_RevealHistoryModel) _then) = __$RevealHistoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String participantId, String participantName, String matchId, String receiverId, String receiverName, DateTime revealedAt, String eventId
});




}
/// @nodoc
class __$RevealHistoryModelCopyWithImpl<$Res>
    implements _$RevealHistoryModelCopyWith<$Res> {
  __$RevealHistoryModelCopyWithImpl(this._self, this._then);

  final _RevealHistoryModel _self;
  final $Res Function(_RevealHistoryModel) _then;

/// Create a copy of RevealHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? participantId = null,Object? participantName = null,Object? matchId = null,Object? receiverId = null,Object? receiverName = null,Object? revealedAt = null,Object? eventId = null,}) {
  return _then(_RevealHistoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,participantName: null == participantName ? _self.participantName : participantName // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,receiverId: null == receiverId ? _self.receiverId : receiverId // ignore: cast_nullable_to_non_nullable
as String,receiverName: null == receiverName ? _self.receiverName : receiverName // ignore: cast_nullable_to_non_nullable
as String,revealedAt: null == revealedAt ? _self.revealedAt : revealedAt // ignore: cast_nullable_to_non_nullable
as DateTime,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
