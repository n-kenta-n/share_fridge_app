import 'package:freezed_annotation/freezed_annotation.dart';
part 'request.freezed.dart';
part 'request.g.dart';

@freezed
abstract class Request with _$Request {
  const factory Request({
    required int id,
    DateTime? createdAt,
    required String fromUserId,
    required String fromUserName,
    required String fromUserEmail,
    required String? toUserName,
    required String toUserEmail,
    required String status,
  }) = _Request;

  factory Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);
}