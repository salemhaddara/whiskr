import 'package:flutter/material.dart';
import 'package:whiskr/model/profile.dart';

class ProfileDetailsPage extends StatelessWidget {
  final ProfileModel profile;
  const ProfileDetailsPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(profile.name),),
      body: Padding(padding:EdgeInsets.all(20),
      child: Column(
        children: [
          
        ],
      ),
      ),
    );
  }
}
