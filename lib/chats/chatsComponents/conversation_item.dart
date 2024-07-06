// ignore_for_file: must_be_immutable,file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whiskr/components/text400normal.dart';
import 'package:whiskr/models/Conversation.dart';
import 'package:whiskr/chats/chat_functions/formatDate.dart';

class ConversationItem extends StatefulWidget {
  Function(Conversation conversation) onClick;
  Conversation conversationInfo;
  ConversationItem(
      {super.key, required this.onClick, required this.conversationInfo});

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String uid=FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Material(
        elevation: 0,
        shadowColor: const Color.fromARGB(255, 156, 210, 255),
        color: widget.conversationInfo.user_notification_count > 0
            ? const Color.fromARGB(255, 156, 210, 255)
            : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        child: GestureDetector(
          onTap: () {
            widget.onClick(widget.conversationInfo);
          },
          child: SizedBox(
            height: 100,
            child: Column(children: [
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        height: 72,
                        width: 67,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child:uid==widget.conversationInfo.user2_id? widget.conversationInfo.user_profile1 == null ||
                                  widget.conversationInfo.user_profile1!.isEmpty
                              ? const Icon(Icons.person_2_outlined)
                              : Image.network(
                                  widget.conversationInfo.user_profile1!,
                                  fit: BoxFit.cover,
                                ):widget.conversationInfo.user_profile1 == null ||
                              widget.conversationInfo.user_profile1!.isEmpty
                              ? const Icon(Icons.person_2_outlined)
                              : Image.network(
                            widget.conversationInfo.user_profile1!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                children: [
                                  text400normal(
                                      align: TextAlign.start,
                                      text:uid==widget.conversationInfo.user_id1?widget.conversationInfo.user_name2: widget.conversationInfo.user_name1,
                                      fontsize: 16,
                                      color: Colors.black),
                                  const Spacer(),
                                  text400normal(
                                      text: formatDate.fromdatetoString(
                                          widget.conversationInfo.last_use),
                                      color: Colors.black,
                                      fontsize: 12)
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  alignment: AlignmentDirectional.centerStart,
                                  child: text400normal(
                                      align: TextAlign.start,
                                      text: widget.conversationInfo
                                                  .last_message.length >
                                              25
                                          ? ' ${widget.conversationInfo.last_message.substring(0, 25)}...'
                                          : widget.conversationInfo.last_message,
                                      fontsize: 14,
                                      color: Colors.black),
                                ),
                                const Spacer(),
                                if (widget.conversationInfo.user_notification_count !=
                                    0)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsetsDirectional.only(
                                        end: 10),
                                    decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle),
                                    child: text400normal(
                                      fontsize: 12,
                                      color: Colors.white,
                                      text:
                                          '${widget.conversationInfo.user_notification_count}',
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
