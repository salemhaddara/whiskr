// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      last_message: json['last_message'] as String,
      user_profile1: json['user_profile1'] as String?,
      user_profile2: json['user_profile2'] as String?,
      last_use: const FirestoreDateConverter()
          .fromJson(json['last_use'] as Timestamp),
      user_id1: json['user_id1'] as String,
      user2_id: json['user2_id'] as String,
      user_name1: json['user_name1'] as String,
      user_name2: json['user_name2'] as String,
      conversation_id: json['conversation_id'] as String,
      user_notification_count: (json['user_notification_count'] as num).toInt(),
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'last_message': instance.last_message,
      'user_profile1': instance.user_profile1,
      'user_profile2': instance.user_profile2,
      'last_use': const FirestoreDateConverter().toJson(instance.last_use),
      'user_id1': instance.user_id1,
      'user2_id': instance.user2_id,
      'user_name1': instance.user_name1,
      'user_name2': instance.user_name2,
      'conversation_id': instance.conversation_id,
      'user_notification_count': instance.user_notification_count,
    };
