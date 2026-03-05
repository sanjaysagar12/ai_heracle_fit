import 'package:flutter/material.dart';

class DietPlan {
  final String name;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final IconData icon;
  final Color color;

  DietPlan({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.icon,
    required this.color,
  });
}

final List<DietPlan> mockDietPlans = [
  DietPlan(
    name: 'Strength & Muscle',
    description:
        'High protein focus to support muscle growth and recovery after intense training session.',
    calories: 2800,
    protein: 210,
    carbs: 310,
    icon: Icons.fitness_center_rounded,
    color: Colors.blueAccent,
  ),
  DietPlan(
    name: 'Lean & Toned',
    description:
        'Moderate protein and lower carb intake to help maintain muscle while reducing body fat.',
    calories: 2100,
    protein: 160,
    carbs: 180,
    icon: Icons.monitor_weight_rounded,
    color: Colors.teal,
  ),
];
