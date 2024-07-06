// ignore_for_file: non_constant_identifier_names

class Conversation {
  String last_message;
  String? user_profile;
  DateTime last_use;
  String user_id, user2_id;
  String user_name;
  String conversation_id;

  int user_notification_count;
  Conversation({
    required this.user_name,
    this.user_profile,
    required this.last_message,
    required this.last_use,
    required this.user_id,
    required this.user2_id,
    required this.conversation_id,
    required this.user_notification_count,
  });
}
