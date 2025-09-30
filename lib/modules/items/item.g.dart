// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Item _$ItemFromJson(Map<String, dynamic> json) => _Item(
  id: (json['id'] as num).toInt(),
  userId: json['userId'] as String,
  itemName: json['itemName'] as String,
  amount: (json['amount'] as num).toDouble(),
  unit: json['unit'] as String,
  limitDate:
      json['limitDate'] == null
          ? null
          : DateTime.parse(json['limitDate'] as String),
  fridgeId: json['fridgeId'] as String,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'itemName': instance.itemName,
  'amount': instance.amount,
  'unit': instance.unit,
  'limitDate': instance.limitDate?.toIso8601String(),
  'fridgeId': instance.fridgeId,
  'imageUrl': instance.imageUrl,
};
