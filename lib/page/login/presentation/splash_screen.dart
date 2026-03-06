import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/services/auth_service.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/page/dashboard/presentation/dashboard_screen.dart';
import 'package:ai_heracle_fit/page/login/presentation/login_screen.dart';

/// Shown at startup. Reads SharedPreferences for a stored JWT.
/// If a token exists → navigate to [DashboardScreen].
/// Otherwise → navigate to [LoginScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final jwt = await AuthService().getStoredJwt();

    if (!mounted) return;

    final Widget destination = jwt != null
        ? const DashboardScreen()
        : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simple branded splash while the check completes
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [HeracleTheme.bgPink, Colors.white, HeracleTheme.bgBlue],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      HeracleTheme.primaryPurple,
                      HeracleTheme.primaryPurple.withOpacity(0.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HeracleTheme.primaryPurple.withOpacity(0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1B20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'HERACLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
