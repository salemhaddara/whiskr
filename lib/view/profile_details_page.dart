import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:whiskr/model/profile.dart';

import '../chats/chat_functions/conversationStream.dart';

class ProfileDetailsPage extends StatefulWidget {
  final ProfileModel profile;

  const ProfileDetailsPage({super.key, required this.profile});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CarouselSlider(
                  items: widget.profile.photos
                      .map((e) => Container(
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(e),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      height: 300, viewportFraction: 1, autoPlay: true)),
              Container(
                height: 75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 10,
                  child: BackButton(
                    color: Colors.white,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  widget.profile.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.birthdayCake,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.profile.dob.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Bio:",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  widget.profile.bio,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  "Animal Type:",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    FaIcon(
                      widget.profile.type.name == "cat"
                          ? FontAwesomeIcons.cat
                          : FontAwesomeIcons.dog,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.profile.type.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
            onPressed: () async {
              loading = true;
              setState(() {});
              final String conversationID =
                  await ConversationsStream.newChat(widget.profile.uid);

              if (!mounted) return;
              context.go('/chats/$conversationID');
            },
            child: const Text("Start Chat now")),
      ),
    );
  }
}
