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
      },
    );
  }

  void onTap(DocumentSnapshot<Map<String, dynamic>> document) {}

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
            onTap: (doc) =>
                onTap(doc as DocumentSnapshot<Map<String, dynamic>>),
          );
        },
      ),
    );
  }
}

class MessageGridTile extends StatefulWidget {
  final ProfileModel profile;
  final int index;
  final void Function(DocumentSnapshot) onTap;

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
    return GridTile(
      header: GridTileBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        title: Text(widget.profile.name),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        title: Text(widget.profile.dob.toString()),
        subtitle: Text(widget.profile.type.name),
      ),
      child: Image.network(widget.profile.photos.first),
    );
  }
}
