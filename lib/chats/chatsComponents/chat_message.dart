// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:whiskr/components/text400normal.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMyMessage;
  final String time;
  final String? user2Id;
  final String? profile;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isMyMessage,
    required this.time,
    required this.user2Id,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMyMessage)
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child:
                          profile == null || user2Id == null || user2Id!.isEmpty
                              ? const Icon(Icons.person)
                              : Image.network(
                                  profile!,
                                  fit: BoxFit.cover,
                                )),
                ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    constraints: const BoxConstraints(maxWidth: 290),
                    decoration: BoxDecoration(
                      color: isMyMessage ? Colors.blue : Colors.black,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: text400normal(
                      text: text,
                      color: isMyMessage ? Colors.white : Colors.grey,
                      fontsize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(children: [
                      text400normal(
                        text: time,
                        color: Colors.grey,
                        fontsize: 12,
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
