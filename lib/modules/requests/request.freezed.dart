// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Request {

 int get id; DateTime? get createdAt; String get fromUserId; String get fromUserName; String get fromUserEmail; String? get toUserName; String get toUserEmail; String get status;
/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestCopyWith<Request> get copyWith => _$RequestCopyWithImpl<Request>(this as Request, _$identity);

  /// Serializes this Request to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Request&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromUserName, fromUserName) || other.fromUserName == fromUserName)&&(identical(other.fromUserEmail, fromUserEmail) || other.fromUserEmail == fromUserEmail)&&(identical(other.toUserName, toUserName) || other.toUserName == toUserName)&&(identical(other.toUserEmail, toUserEmail) || other.toUserEmail == toUserEmail)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,fromUserId,fromUserName,fromUserEmail,toUserName,toUserEmail,status);

@override
String toString() {
  return 'Request(id: $id, createdAt: $createdAt, fromUserId: $fromUserId, fromUserName: $fromUserName, fromUserEmail: $fromUserEmail, toUserName: $toUserName, toUserEmail: $toUserEmail, status: $status)';
}


}

/// @nodoc
abstract mixin class $RequestCopyWith<$Res>  {
  factory $RequestCopyWith(Request value, $Res Function(Request) _then) = _$RequestCopyWithImpl;
@useResult
$Res call({
 int id, DateTime? createdAt, String fromUserId, String fromUserName, String fromUserEmail, String? toUserName, String toUserEmail, String status
});




}
/// @nodoc
class _$RequestCopyWithImpl<$Res>
    implements $RequestCopyWith<$Res> {
  _$RequestCopyWithImpl(this._self, this._then);

  final Request _self;
  final $Res Function(Request) _then;

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = freezed,Object? fromUserId = null,Object? fromUserName = null,Object? fromUserEmail = null,Object? toUserName = freezed,Object? toUserEmail = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,fromUserName: null == fromUserName ? _self.fromUserName : fromUserName // ignore: cast_nullable_to_non_nullable
as String,fromUserEmail: null == fromUserEmail ? _self.fromUserEmail : fromUserEmail // ignore: cast_nullable_to_non_nullable
as String,toUserName: freezed == toUserName ? _self.toUserName : toUserName // ignore: cast_nullable_to_non_nullable
as String?,toUserEmail: null == toUserEmail ? _self.toUserEmail : toUserEmail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Request implements Request {
  const _Request({required this.id, this.createdAt, required this.fromUserId, required this.fromUserName, required this.fromUserEmail, required this.toUserName, required this.toUserEmail, required this.status});
  factory _Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);

@override final  int id;
@override final  DateTime? createdAt;
@override final  String fromUserId;
@override final  String fromUserName;
@override final  String fromUserEmail;
@override final  String? toUserName;
@override final  String toUserEmail;
@override final  String status;

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestCopyWith<_Request> get copyWith => __$RequestCopyWithImpl<_Request>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Request&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromUserName, fromUserName) || other.fromUserName == fromUserName)&&(identical(other.fromUserEmail, fromUserEmail) || other.fromUserEmail == fromUserEmail)&&(identical(other.toUserName, toUserName) || other.toUserName == toUserName)&&(identical(other.toUserEmail, toUserEmail) || other.toUserEmail == toUserEmail)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,fromUserId,fromUserName,fromUserEmail,toUserName,toUserEmail,status);

@override
String toString() {
  return 'Request(id: $id, createdAt: $createdAt, fromUserId: $fromUserId, fromUserName: $fromUserName, fromUserEmail: $fromUserEmail, toUserName: $toUserName, toUserEmail: $toUserEmail, status: $status)';
}


}

/// @nodoc
abstract mixin class _$RequestCopyWith<$Res> implements $RequestCopyWith<$Res> {
  factory _$RequestCopyWith(_Request value, $Res Function(_Request) _then) = __$RequestCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime? createdAt, String fromUserId, String fromUserName, String fromUserEmail, String? toUserName, String toUserEmail, String status
});




}
/// @nodoc
class __$RequestCopyWithImpl<$Res>
    implements _$RequestCopyWith<$Res> {
  __$RequestCopyWithImpl(this._self, this._then);

  final _Request _self;
  final $Res Function(_Request) _then;

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = freezed,Object? fromUserId = null,Object? fromUserName = null,Object? fromUserEmail = null,Object? toUserName = freezed,Object? toUserEmail = null,Object? status = null,}) {
  return _then(_Request(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,fromUserName: null == fromUserName ? _self.fromUserName : fromUserName // ignore: cast_nullable_to_non_nullable
as String,fromUserEmail: null == fromUserEmail ? _self.fromUserEmail : fromUserEmail // ignore: cast_nullable_to_non_nullable
as String,toUserName: freezed == toUserName ? _self.toUserName : toUserName // ignore: cast_nullable_to_non_nullable
as String?,toUserEmail: null == toUserEmail ? _self.toUserEmail : toUserEmail // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
