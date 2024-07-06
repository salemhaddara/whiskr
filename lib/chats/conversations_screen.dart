// ignore_for_file: file_names, camel_case_types, must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whiskr/chats/chat_functions/conversationStream.dart';
import 'package:whiskr/chats/chat_screen.dart';
import 'package:whiskr/chats/chatsComponents/conversation_item.dart';
import 'package:whiskr/components/top_bar.dart';
import 'package:whiskr/models/Conversation.dart';

class ConversationsScreen extends StatefulWidget {
  String? payload;

  ConversationsScreen({super.key, this.payload});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  late final StreamSubscription _subscription;
  List<Conversation> conversations = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      error = 'User not found';
      return;
    }

    _subscription = FirebaseFirestore.instance
        .collection('chats')
        .where(Filter.or(
          Filter("user_id1", isEqualTo: userId),
          Filter("user2_id", isEqualTo: userId),
        ))
        .snapshots()
        .listen(
      (snapshot) async {
        if (loading) {
          loading = false;
          setState(() {});
        }
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data();
          final Conversation conversation = Conversation.fromJson(data);

          conversations.add(conversation);
        }

        if (mounted) {
          setState(() {});
        }
      },
      onError: (error) {
        print(error);
        this.error = error.toString();
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(widget.payload);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            topBar(
              size: size,
              text: "Conversations",
              onBack: null,
            ),
            const SizedBox(height: 2),
            if (error != null)
              Expanded(
                child: Center(
                  child: Text(error!),
                ),
              )
            else if (loading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: conversations.length,
                  padding: const EdgeInsets.only(top: 0),
                  itemBuilder: (context, index) {
                    return ConversationItem(
                      onClick: (conversation) async {
                        ConversationsStream.markConversationAsRead(
                            conversation.conversation_id,
                            conversation.user_id1);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ChatScreen(
                            conversationID: '',
                          );
                        }));
                      },
                      conversationInfo: conversations[index],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
