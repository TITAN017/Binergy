import 'package:binergy/screens/auth/wrapper.dart';
import 'package:binergy/screens/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  redirect: (ctx, state) {
    if (FirebaseAuth.instance.currentUser != null) {
      return '/home';
    }
    return '/';
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Wrapper(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
