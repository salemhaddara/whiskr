import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),
      
      ),
      body: ProfileScreen(
        avatar: SizedBox(),
        
        providers: providers,
            actions: [
              SignedOutAction((context) {
                context.go('/auth');
              }),
            ],
        children: [
          // Text("data")
        ],
      ),
    );
  }
}
