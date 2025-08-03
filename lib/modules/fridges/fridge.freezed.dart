// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fridge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Fridge {

 String get fridgeId; String get userName;
/// Create a copy of Fridge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FridgeCopyWith<Fridge> get copyWith => _$FridgeCopyWithImpl<Fridge>(this as Fridge, _$identity);

  /// Serializes this Fridge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fridge&&(identical(other.fridgeId, fridgeId) || other.fridgeId == fridgeId)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fridgeId,userName);

@override
String toString() {
  return 'Fridge(fridgeId: $fridgeId, userName: $userName)';
}


}

/// @nodoc
abstract mixin class $FridgeCopyWith<$Res>  {
  factory $FridgeCopyWith(Fridge value, $Res Function(Fridge) _then) = _$FridgeCopyWithImpl;
@useResult
$Res call({
 String fridgeId, String userName
});




}
/// @nodoc
class _$FridgeCopyWithImpl<$Res>
    implements $FridgeCopyWith<$Res> {
  _$FridgeCopyWithImpl(this._self, this._then);

  final Fridge _self;
  final $Res Function(Fridge) _then;

/// Create a copy of Fridge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fridgeId = null,Object? userName = null,}) {
  return _then(_self.copyWith(
fridgeId: null == fridgeId ? _self.fridgeId : fridgeId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Fridge implements Fridge {
  const _Fridge({required this.fridgeId, required this.userName});
  factory _Fridge.fromJson(Map<String, dynamic> json) => _$FridgeFromJson(json);

@override final  String fridgeId;
@override final  String userName;

/// Create a copy of Fridge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FridgeCopyWith<_Fridge> get copyWith => __$FridgeCopyWithImpl<_Fridge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FridgeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fridge&&(identical(other.fridgeId, fridgeId) || other.fridgeId == fridgeId)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fridgeId,userName);

@override
String toString() {
  return 'Fridge(fridgeId: $fridgeId, userName: $userName)';
}


}

/// @nodoc
abstract mixin class _$FridgeCopyWith<$Res> implements $FridgeCopyWith<$Res> {
  factory _$FridgeCopyWith(_Fridge value, $Res Function(_Fridge) _then) = __$FridgeCopyWithImpl;
@override @useResult
$Res call({
 String fridgeId, String userName
});




}
/// @nodoc
class __$FridgeCopyWithImpl<$Res>
    implements _$FridgeCopyWith<$Res> {
  __$FridgeCopyWithImpl(this._self, this._then);

  final _Fridge _self;
  final $Res Function(_Fridge) _then;

/// Create a copy of Fridge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fridgeId = null,Object? userName = null,}) {
  return _then(_Fridge(
fridgeId: null == fridgeId ? _self.fridgeId : fridgeId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
