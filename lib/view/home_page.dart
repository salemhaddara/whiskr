import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whiskr/chats/chat_functions/conversationStream.dart';
import 'package:whiskr/model/profile.dart';
import 'package:whiskr/view/profile_page.dart';

import '../chats/conversations_screen.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  final PageController controller = PageController();
  int index = 0;

  bool loading = true;
  ProfileModel? myModel;

  @override
  void initState() {
    super.initState();

    ConversationsStream.getProfile(FirebaseAuth.instance.currentUser!.uid)
        .then((value) {
      myModel = value;
      setState(() {});
    }).catchError((error) {
      context.go('/profile');
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) {
          this.index = index;
          setState(() {});
          controller.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
          );
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
        title: const Row(
          children: [
            Icon(Icons.pets),
            SizedBox(width: 16),
            Text('Whiskr'),
          ],
        ),
      ),
      body: PageView(
        controller: controller,
        children: [
          const HomePage(),
          ConversationsScreen(),
          ProfilePage(model: myModel),
        ],
      ),
    );
  }
}

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
        profiles
          ..addAll(
            event.docs.map((e) => ProfileModel.fromJson(e.data())).toList(),
          )
          ..removeWhere((profile) =>
              profile.uid == FirebaseAuth.instance.currentUser!.uid);
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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        return ProfileTile(
          index: index,
          profile: profile,
          onTap: () => onTap(profile),
        );
      },
    );
  }
}

class ProfileTile extends StatefulWidget {
  final ProfileModel profile;
  final int index;
  final VoidCallback onTap;

  const ProfileTile({
    super.key,
    required this.profile,
    required this.index,
    required this.onTap,
  });

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Image.network(
            widget.profile.photos.first,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return Stack(
                children: [
                  Positioned.fill(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.3),
                      highlightColor: Colors.grey.withOpacity(0.1),
                      child: Container(color: Colors.black),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: frame == null ? 0 : 1,
                    child: child,
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.profile.name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.profile.dob.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
