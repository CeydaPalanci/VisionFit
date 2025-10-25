import 'package:flutter/material.dart';
import 'package:visio_fit/layouts/main_navigation_bar.dart';
import 'package:visio_fit/pages/login/login_page.dart';
import 'package:visio_fit/pages/main/camera_page.dart';
import 'package:visio_fit/pages/main/profile_page.dart';
import 'package:visio_fit/pages/main/start_page.dart';
import 'package:visio_fit/pages/register/register_page.dart';

class AppRouter {
  static const String start = '/';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String camera = '/camera';
  static const String main = '/main';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return MaterialPageRoute(builder: (_) => const StartPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case camera:
        return MaterialPageRoute(builder: (_) => const CameraPage());
      case main:
        final args = settings.arguments as Map<String, dynamic>?;

        final initialIndex = args?['initialIndex'] ?? 0;
        final faceShapeFilter = args?['faceShapeFilter'] ?? "";

        return MaterialPageRoute(
          builder: (_) => MainNavigationBar(
            initialIndex: initialIndex,
            faceShapeFilter: faceShapeFilter,
          ),
        );

      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
