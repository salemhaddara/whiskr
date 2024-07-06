import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whiskr/model/profile.dart';
import 'package:whiskr/models/Conversation.dart';

class ConversationsStream {
  Stream<List<Conversation>> getConversationsStream() async* {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      yield [];
      return;
    }

    yield* FirebaseFirestore.instance
        .collection('chats')
        .where(Filter.or(
          Filter("user_id", isEqualTo: userId),
          Filter("user2_id", isEqualTo: userId),
        ))
        .snapshots()
        .asyncMap((snapshot) async {
      List<Conversation> conversations = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        DateTime lastUse = (data['last_use'] as Timestamp).toDate();

        // Fetch user2's profile to get the username
        ProfileModel? user2Profile = await getMyUsername(data['user2_id']);

        if (user2Profile != null) {
          conversations.add(Conversation(
            user_name1: userId == data['user_id']
                ? data['username1']
                : data['username2'],
            user_profile1: data['profile'],
            last_message: data['last_message'],
            last_use: lastUse,
            user2_id: data['user2_id'],
            user_id1: data['user_id'],
            conversation_id: doc.id,
            user_notification_count: data['user_notification_count'],
            user_name2: user2Profile.name,
          ));
        } else {
          throw Exception("The user doesn't have a username");
        }
      }
      return conversations;
    });
  }

  Future<bool> markConversationAsRead(
      String conversationId, String userId) async {
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

  Future<Conversation?> joinChat(
      String conversationId,
      String profile,
      String name,
      String lastMessage,
      String user2Id,
      DateTime chatTime) async {
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
        'last_message': lastMessage,
        'user2_id': user2Id,
        'user_id': userId,
        'user_notification_count': 0
      };

      // Set the data in the subcollection document
      await conversationRef.set(newData);
      return Conversation.fromMap(newData);
    }
  }

  Future<ProfileModel?> getMyUsername(String userId) async {
    try {
      // Fetch the document from the "profiles" collection
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection("profiles")
              .doc(userId)
              .get();

      if (documentSnapshot.exists) {
        var document = documentSnapshot.data()!;
        ProfileModel profile = ProfileModel.fromJson({...document});
        return profile;
      } else {
        // Handle the case where the document does not exist
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error fetching user data: $e");
      return null;
    }
  }
}
