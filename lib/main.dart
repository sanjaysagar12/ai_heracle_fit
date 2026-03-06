import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/page/login/presentation/splash_screen.dart';

import 'package:ai_heracle_fit/core/services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Heracle Fit',
      debugShowCheckedModeBanner: false,
      theme: HeracleTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
