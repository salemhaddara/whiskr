import 'package:go_router/go_router.dart';
import 'package:whiskr/view/home_page.dart';
import 'package:whiskr/view/profile_details_page.dart';
import 'package:whiskr/view/profile_page.dart';

import 'model/profile.dart';
import 'view/auth_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  // redirect: (context, state) {
  //   final user = FirebaseAuth.instance.currentUser;
  //
  //   if (user == null) {
  //     return '/auth';
  //   } else {
  //     return '/';
  //   }
  // },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/profile-details',
      builder: (context, state) => ProfileDetailsPage(
        profile: state.extra as ProfileModel,
      ),
    ),
  ],
);
