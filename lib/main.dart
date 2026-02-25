import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/page/login/presentation/login_screen.dart';

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
      title: 'Heracle Fit',
      debugShowCheckedModeBanner: false,
      theme: HeracleTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
