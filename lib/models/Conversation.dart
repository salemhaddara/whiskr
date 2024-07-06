// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Conversation.g.dart';

class FirestoreDateConverter implements JsonConverter<DateTime, Timestamp> {
  const FirestoreDateConverter();

  @override
  DateTime fromJson(Timestamp value) {
    return DateTime.fromMillisecondsSinceEpoch(value.millisecondsSinceEpoch);
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class Conversation {
  final String last_message;
  final String? user_profile1, user_profile2;

  @FirestoreDateConverter()
  final DateTime last_use;

  final String user_id1, user2_id;
  final String user_name1, user_name2;
  final String conversation_id;
  final int user_notification_count;

  Conversation({
    required this.last_message,
    required this.user_profile1,
    required this.user_profile2,
    required this.last_use,
    required this.user_id1,
    required this.user2_id,
    required this.user_name1,
    required this.user_name2,
    required this.conversation_id,
    required this.user_notification_count,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}
