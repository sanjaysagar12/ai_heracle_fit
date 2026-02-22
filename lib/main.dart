import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/page/auth/presentation/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
