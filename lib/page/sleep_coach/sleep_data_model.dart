import 'package:flutter/material.dart';

class SleepData {
  final String day;
  final double hours;
  final int qualityScore;

  SleepData({
    required this.day,
    required this.hours,
    required this.qualityScore,
  });
}

class SleepTip {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  SleepTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

final List<SleepData> mockSleepHistory = [
  SleepData(day: 'Mon', hours: 7.2, qualityScore: 82),
  SleepData(day: 'Tue', hours: 6.5, qualityScore: 75),
  SleepData(day: 'Wed', hours: 8.0, qualityScore: 90),
  SleepData(day: 'Thu', hours: 7.5, qualityScore: 85),
  SleepData(day: 'Fri', hours: 7.0, qualityScore: 80),
  SleepData(day: 'Sat', hours: 9.2, qualityScore: 95),
  SleepData(day: 'Sun', hours: 8.4, qualityScore: 88),
];

final List<SleepTip> mockSleepTips = [
  SleepTip(
    title: 'Magnesium Intake',
    description: 'Try taking magnesium 30 mins before bed for deeper muscle relaxation.',
    icon: Icons.spa_rounded,
    color: const Color(0xFF7B61FF),
  ),
  SleepTip(
    title: 'Digital Detox',
    description: 'Avoid blue light from screens at least 1 hour before your target bedtime.',
    icon: Icons.phonelink_off_rounded,
    color: const Color(0xFFE91E63),
  ),
  SleepTip(
    title: 'Optimal Temperature',
    description: 'Keep your room around 18°C (65°F) for the best restorative sleep.',
    icon: Icons.ac_unit_rounded,
    color: const Color(0xFF2196F3),
  ),
];
