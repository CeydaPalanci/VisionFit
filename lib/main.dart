import 'dart:io';

import 'package:flutter/material.dart';
import 'package:visio_fit/layouts/main_navigation_bar.dart';
import 'package:visio_fit/pages/login/login_page.dart';
import 'package:visio_fit/pages/main/camera_page.dart';
import 'package:visio_fit/pages/main/glasses_screen.dart';
// import 'package:visio_fit/pages/login/login_page.dart';
// import 'package:visio_fit/pages/main/start_page.dart';
// import 'package:visio_fit/utils/router.dart';
import 'package:visio_fit/pages/main/result_page.dart';
import 'package:visio_fit/pages/main/start_page.dart';
import 'package:visio_fit/utils/router.dart';
import 'package:visio_fit/utils/theme.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides(); // SSL doğrulamayı devre dışı bırak
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Visio Fit',
      theme: AppTheme.lightTheme,
       initialRoute: AppRouter.login,
       onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

