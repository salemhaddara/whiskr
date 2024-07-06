import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
    return Scaffold(
      appBar: AppBar(title: Text("Authentication"),),
      body: SignInScreen(
        providers: providers,
        actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                // Navigator.pushReplacementNamed(context, '/');
                context.go("/");
              }),
              AuthStateChangeAction<UserCreated>((context, state) {
                // Navigator.pushReplacementNamed(context, '/');
                context.go("/profile");
              }),
            ],
      ),
    );
  }
}
