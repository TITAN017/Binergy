import 'package:binergy/screens/auth/wrapper.dart';
import 'package:binergy/screens/home/homepage.dart';
import 'package:binergy/screens/scan/qr_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:binergy/shared/route_animation.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
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
    GoRoute(
      path: '/scan',
      pageBuilder: (context, state) {
        return RouteAnimation.routeAnimation(context, state, const QRScanner());
      },
    ),
  ],
);
