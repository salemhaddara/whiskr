// ignore_for_file: camel_case_types, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whiskr/models/Message.dart';

class chatStream {
  Stream<List<Message>> getMessagesStream(String conversationId) async* {
    yield* FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        DateTime time = (data['time'] as Timestamp).toDate();
        return Message(
          time,
          data['receiverId'],
          data['senderId'],
          data['text'],
        );
      }).toList();
    });
  }

  Future<void> sendMessage(String conversationId, String senderId,
      String receiverId, String text) async {
    try {
      CollectionReference messagesCollection = FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages');
      DateTime currentTime = DateTime.now();
      await messagesCollection.add({
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'time': currentTime,
      });
      DocumentReference conversationRef =
          FirebaseFirestore.instance.collection('chats').doc(conversationId);
      conversationRef.update({
        'last_use': currentTime,
        'last_message': text,
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
