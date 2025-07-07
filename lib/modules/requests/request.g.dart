// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Request _$RequestFromJson(Map<String, dynamic> json) => _Request(
  id: (json['id'] as num).toInt(),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  fromUserId: json['fromUserId'] as String,
  fromUserName: json['fromUserName'] as String,
  fromUserEmail: json['fromUserEmail'] as String,
  toUserName: json['toUserName'] as String?,
  toUserEmail: json['toUserEmail'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$RequestToJson(_Request instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt?.toIso8601String(),
  'fromUserId': instance.fromUserId,
  'fromUserName': instance.fromUserName,
  'fromUserEmail': instance.fromUserEmail,
  'toUserName': instance.toUserName,
  'toUserEmail': instance.toUserEmail,
  'status': instance.status,
};
