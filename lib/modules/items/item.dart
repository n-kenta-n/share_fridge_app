import 'package:freezed_annotation/freezed_annotation.dart';
part 'item.freezed.dart';
part 'item.g.dart';

@freezed
abstract class Item with _$Item {
  const factory Item({
    required int id,
    required String userId,
    required String itemName,
    required double amount,
    required String unit,
    required DateTime? limitDate,
    required String fridgeId,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}