// ignore_for_file: must_be_immutable, library_private_types_in_public_api,file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whiskr/chats/chat_functions/chatStream.dart';
import 'package:whiskr/chats/chatsComponents/chat_message.dart';
import 'package:whiskr/components/top_bar.dart';
import 'package:whiskr/models/Conversation.dart';
import 'package:whiskr/models/Message.dart';
import 'package:whiskr/chats/chat_functions/formatDate.dart';

class ChatScreen extends StatefulWidget {
  Conversation conversation;

  ChatScreen({super.key, required this.conversation});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = List.empty(growable: true);
  final TextEditingController _textController = TextEditingController();
  late Size size;
  final stream = chatStream();
  String doctorToken = '';

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    String myId = widget.conversation.user_id1;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              topBar(
                size: size,
                text: widget.conversation.user_name1,
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: stream.getMessagesStream(
                          widget.conversation.conversation_id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Message> newMessages =
                              List.from(snapshot.data ?? []);
                          newMessages.removeWhere((newMessage) => _messages.any(
                              (existingMessage) =>
                                  newMessage.time == existingMessage.time &&
                                  newMessage.text == existingMessage.text &&
                                  newMessage.senderId ==
                                      existingMessage.senderId));

                          _messages.insertAll(0, newMessages);
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _messages.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return ChatMessage(
                              text: _messages[index].text,
                              isMyMessage: myId == _messages[index].senderId,
                              time: formatDate
                                  .fromdatetoString(_messages[index].time),
                              user2Id: widget.conversation.user_profile1,
                            );
                          },
                        );
                      })),
              const Divider(height: 1.0),
              _buildTextComposer(),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 156, 210, 255),
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'write here your message',
              ),
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.none,
                  color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  _handleSubmitted(String text) {
    _textController.clear();
    if (text.isNotEmpty) {
      stream.sendMessage(
        widget.conversation.conversation_id,
        widget.conversation.user_id1,
        widget.conversation.user2_id,
        text,
      );
    }
  }
}
