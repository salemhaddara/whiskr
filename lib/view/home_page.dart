import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whiskr/model/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamSubscription<QuerySnapshot> _subscription;
  final List<ProfileModel> profiles = [];

  @override
  void initState() {
    super.initState();
    _subscription =
        FirebaseFirestore.instance.collection('profiles').snapshots().listen(
      (event) {
        profiles.clear();
        profiles.addAll(
          event.docs.map((e) => ProfileModel.fromJson(e.data())).toList(),
        );
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void onTap(ProfileModel profile) {
    context.go('/profile-details', extra: profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.go('/chats');
          } else if (index == 2) {
            context.go('/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Whisker'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return MessageGridTile(
            index: index,
            profile: profile,
            onTap: () => onTap(profile),
          );
        },
      ),
    );
  }
}

class MessageGridTile extends StatefulWidget {
  final ProfileModel profile;
  final int index;
  final VoidCallback onTap;

  const MessageGridTile({
    super.key,
    required this.profile,
    required this.index,
    required this.onTap,
  });

  @override
  State<MessageGridTile> createState() => _MessageGridTileState();
}

class _MessageGridTileState extends State<MessageGridTile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.profile.photos.first,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.profile.name,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
