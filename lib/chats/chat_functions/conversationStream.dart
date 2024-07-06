// ignore_for_file: file_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whiskr/models/Conversation.dart';

class ConversationsStream {
  Stream<List<Conversation>> getConversationsStream() async* {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    yield* FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('userchats')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        print("salem $data");
        DateTime lastUse = (data['last_use'] as Timestamp).toDate();

        return Conversation(
          user_name: data['username'],
          user_profile: data['profile'],
          last_message: data['last_message'],
          last_use: lastUse,
          user2_id: data['user2_id'],
          user_id: data['user_id'],
          conversation_id: doc.id,
          user_notification_count: data['user_notification_count'],
        );
      }).toList();
    });
  }

  Future<bool> markConversationAsRead(String conversationId, userId) async {
    try {
      DocumentReference conversationRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(userId)
          .collection('userchats')
          .doc(conversationId);

      await conversationRef.update({'user_notification_count': 0});

      return true; // Marked as read successfully
    } catch (e) {
      print('Error marking conversation as read: $e');
      return false; // Marking as read failed
    }
  }

  Future<Conversation?> JoinChat(String conversationId, profile, name,
      lastmessage, user2id, DateTime chatTime) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference userChats = FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('userchats');

    DocumentReference conversationRef = userChats.doc(conversationId);

    DocumentSnapshot conversationSnapshot = await conversationRef.get();

    if (conversationSnapshot.exists) {
      Map<String, dynamic> conversationData =
          conversationSnapshot.data() as Map<String, dynamic>;

      return Conversation.fromMap(conversationData);
    } else {
      DateTime now = DateTime.now();

      // Create the data to be added
      Map<String, dynamic> newData = {
        'last_use': now,
        'profile': profile,
        'username': name,
        'last_message': lastmessage,
        'user2_id': user2id,
        'user_id': userId,
        'user_notification_count': 0
      };

      // Set the data in the subcollection document
      await conversationRef.set(newData);
      return Conversation.fromMap(newData);
    }
  }
}
