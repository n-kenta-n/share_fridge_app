import 'package:freezed_annotation/freezed_annotation.dart';
part 'fridge.freezed.dart';
part 'fridge.g.dart';

@freezed
abstract class Fridge with _$Fridge {
  const factory Fridge({
    required String fridgeId,
    required String userName,
  }) = _Fridge;

  factory Fridge.fromJson(Map<String, dynamic> json) => _$FridgeFromJson(json);
}