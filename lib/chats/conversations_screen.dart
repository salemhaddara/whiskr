// ignore_for_file: file_names, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:whiskr/chats/chat_functions/conversationStream.dart';
import 'package:whiskr/chats/chat_screen.dart';
import 'package:whiskr/chats/chatsComponents/conversation_item.dart';
import 'package:whiskr/components/top_bar.dart';
import 'package:whiskr/models/Conversation.dart';

class conversationsScreen extends StatefulWidget {
  String? payload;
  conversationsScreen({super.key, this.payload});

  @override
  State<conversationsScreen> createState() => _conversationsScreenState();
}

class _conversationsScreenState extends State<conversationsScreen> {
  final stream = ConversationsStream();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(widget.payload);
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Conversation>>(
        stream: stream.getConversationsStream(),
        builder: (context, snapshot) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              padding: EdgeInsets.only(top: size.height * .05),
              child: Column(
                children: [
                  topBar(size: size, text: "Conversations"),
                  const SizedBox(height: 2),
                  StreamBuilder<List<Conversation>>(
                      stream: stream.getConversationsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 6,
                              color: Colors.blue,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        List<Conversation> conversations = snapshot.data ?? [];
                        return Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: conversations.length,
                            padding: const EdgeInsets.only(top: 0),
                            itemBuilder: (context, index) {
                              return ConversationItem(
                                  onClick: (conversation) async {
                                    stream.markConversationAsRead(
                                        conversation.conversation_id,
                                        conversation.user_id);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ChatScreen(
                                          conversation: conversation);
                                    }));
                                  },
                                  conversationInfo: Conversation(
                                      user_name: conversations[index].user_name,
                                      user_profile:
                                          conversations[index].user_profile,
                                      last_message:
                                          conversations[index].last_message,
                                      last_use: conversations[index].last_use,
                                      user_id: conversations[index].user_id,
                                      conversation_id:
                                          conversations[index].conversation_id,
                                      user2_id: conversations[index].user2_id,
                                      user_notification_count:
                                          conversations[index]
                                              .user_notification_count));
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
