import 'package:binergy/screens/auth/wrapper.dart';
import 'package:binergy/screens/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:binergy/shared/route_animation.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  redirect: (ctx, state) async {
    if (await Future.delayed(const Duration(milliseconds: 200),
        () => FirebaseAuth.instance.currentUser != null)) {
      return '/home';
    }
    return '/';
  },
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return RouteAnimation.routeAnimation(context, state, const Wrapper());
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return RouteAnimation.routeAnimation(context, state, const HomePage());
      },
    ),
  ],
);
