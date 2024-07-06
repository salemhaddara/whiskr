import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:whiskr/main.dart';

import 'auth.dart';

final GoRouter router = GoRouter(
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return '/login';
    } else {
      return '/home';
    }
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
  ],
);
