// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Item {

 int get id; String get userId; String get itemName; double get amount; String get unit; DateTime? get limitDate; String get fridgeId;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.limitDate, limitDate) || other.limitDate == limitDate)&&(identical(other.fridgeId, fridgeId) || other.fridgeId == fridgeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,itemName,amount,unit,limitDate,fridgeId);

@override
String toString() {
  return 'Item(id: $id, userId: $userId, itemName: $itemName, amount: $amount, unit: $unit, limitDate: $limitDate, fridgeId: $fridgeId)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 int id, String userId, String itemName, double amount, String unit, DateTime? limitDate, String fridgeId
});




}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? itemName = null,Object? amount = null,Object? unit = null,Object? limitDate = freezed,Object? fridgeId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,limitDate: freezed == limitDate ? _self.limitDate : limitDate // ignore: cast_nullable_to_non_nullable
as DateTime?,fridgeId: null == fridgeId ? _self.fridgeId : fridgeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Item implements Item {
  const _Item({required this.id, required this.userId, required this.itemName, required this.amount, required this.unit, required this.limitDate, required this.fridgeId});
  factory _Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

@override final  int id;
@override final  String userId;
@override final  String itemName;
@override final  double amount;
@override final  String unit;
@override final  DateTime? limitDate;
@override final  String fridgeId;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.limitDate, limitDate) || other.limitDate == limitDate)&&(identical(other.fridgeId, fridgeId) || other.fridgeId == fridgeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,itemName,amount,unit,limitDate,fridgeId);

@override
String toString() {
  return 'Item(id: $id, userId: $userId, itemName: $itemName, amount: $amount, unit: $unit, limitDate: $limitDate, fridgeId: $fridgeId)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String userId, String itemName, double amount, String unit, DateTime? limitDate, String fridgeId
});




}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? itemName = null,Object? amount = null,Object? unit = null,Object? limitDate = freezed,Object? fridgeId = null,}) {
  return _then(_Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,limitDate: freezed == limitDate ? _self.limitDate : limitDate // ignore: cast_nullable_to_non_nullable
as DateTime?,fridgeId: null == fridgeId ? _self.fridgeId : fridgeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
