import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Premium User Avatar
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                HeracleTheme.primaryPurple,
                HeracleTheme.primaryPurple.withOpacity(0.5),
              ],
            ),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: HeracleTheme.primaryPurple.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xFFE8E4FD),
            backgroundImage: NetworkImage(
              'https://api.dicebear.com/7.x/avataaars/png?seed=Felix&backgroundColor=b6e3f4,c0aede,d1d4f9',
            ),
          ),
        ),
        const SizedBox(width: 16),
        // User Info & HERACLE branding
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sanjana S', // Simplified name for cleaner header
                    style: HeracleTheme.lightTheme.textTheme.titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          letterSpacing: -1,
                        ),
                  ),
                  const SizedBox(width: 8),
                  // HERACLE Branding Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1B20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'HERACLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Athlete • Pro Member',
                style: TextStyle(
                  color: HeracleTheme.textGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Notification bell
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: HeracleTheme.textBlack,
                  size: 26,
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD600),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
