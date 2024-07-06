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
  factory Conversation.fromMap(Map<String, dynamic> data) {
    return Conversation(
      user_name: data['username'],
      user_profile: data['profile'],
      last_message: data['last_message'],
      last_use: data['last_use'],
      user_id: data['user_id'],
      user2_id: data['user2_id'],
      conversation_id: '', // Provide a value or modify the logic to obtain it
      user_notification_count: data['user_notification_count'] ?? 0,
    );
  }
}
