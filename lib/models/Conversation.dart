// ignore_for_file: non_constant_identifier_names, file_names

class Conversation {
  String last_message;
  String? user_profile1, user_profile2;
  DateTime last_use;
  String user_id1, user2_id;
  String user_name1, user_name2;
  String conversation_id;
  int user_notification_count;

  Conversation({
    required this.user_name1,
    required this.user_name2,
    this.user_profile1,
    this.user_profile2,
    required this.last_message,
    required this.last_use,
    required this.user_id1,
    required this.user2_id,
    required this.conversation_id,
    required this.user_notification_count,
  });
  factory Conversation.fromMap(Map<String, dynamic> data) {
    return Conversation(
      user_name1: data['username1'],
      user_name2: data['username2'],
      user_profile1: data['profile1'],
      user_profile2: data['profile2'],
      last_message: data['last_message'],
      last_use: data['last_use'],
      user_id1: data['user_id1'],
      user2_id: data['user2_id'],
      conversation_id: data['conversation_id'] ?? '',
      user_notification_count: data['user_notification_count'] ?? 0,
    );
  }
}
