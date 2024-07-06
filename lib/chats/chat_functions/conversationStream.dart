import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whiskr/model/profile.dart';
import 'package:whiskr/models/Conversation.dart';

class ConversationsStream {




  static Future<Conversation> getChat(String chatID) async {
    return (FirebaseFirestore.instance.collection('chats').doc(chatID).get())
        .then((snapshot) {
      final data = snapshot.data();

      return Conversation.fromJson(data!);
    });
  }

  static Future<String> newChat(String theirID) async {
    final String myID = FirebaseAuth.instance.currentUser!.uid;
    final ProfileModel myModel = await getProfile(myID);
    final ProfileModel theirModel = await getProfile(theirID);
    DateTime now = DateTime.now();

    final query = await FirebaseFirestore.instance
        .collection('chats')
        .where(Filter.or(
      Filter.and(
          Filter("user_id1", isEqualTo: myID),
          Filter("user2_id", isEqualTo: theirID),),
        Filter.and(
          Filter("user_id1", isEqualTo: theirID),
          Filter("user2_id", isEqualTo: myID),)

        ))
        .get();

    if (query.size == 0) {
      CollectionReference userChats =
          FirebaseFirestore.instance.collection('chats');

      final DocumentReference<Object?> snapshot =
          await userChats.add(Conversation(
        last_message: '',
        user_profile1: myModel.photos.firstOrNull,
        user_profile2: theirModel.photos.firstOrNull,
        last_use: now,
        user_id1: myID,
        user2_id: theirID,
        user_name1: myModel.name,
        user_name2: theirModel.name,
        conversation_id: '',
        user_notification_count: 0,
      ).toJson());

      await userChats.doc(snapshot.id).update({
        'conversation_id': snapshot.id,
      });

      return snapshot.id;
    } else {
      // Return id of existing conversation.
      return query.docs.first.id;
    }
  }

  static Future<Conversation?> joinChat(
      String conversationId,
      String profile,
      String name,
      String lastMessage,
      String user2Id,
      DateTime chatTime) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference userChats =
        FirebaseFirestore.instance.collection('chats');

    DocumentReference conversationRef = userChats.doc(conversationId);

    DocumentSnapshot conversationSnapshot = await conversationRef.get();

    if (conversationSnapshot.exists) {
      Map<String, dynamic> conversationData =
          conversationSnapshot.data() as Map<String, dynamic>;

      return Conversation.fromJson(conversationData);
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
      return Conversation.fromJson(newData);
    }
  }

  static Future<ProfileModel> getProfile(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection("profiles")
            .doc(userId)
            .get();

    var document = documentSnapshot.data()!;
    final ProfileModel profile = ProfileModel.fromJson({...document});
    return profile;
  }
}
