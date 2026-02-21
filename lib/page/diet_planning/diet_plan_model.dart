import 'package:flutter/material.dart';

class DietPlan {
  final String name;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final IconData icon;
  final Color color;

  DietPlan({
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.icon,
    required this.color,
  });
}

final List<DietPlan> mockDietPlans = [
  DietPlan(
    name: 'Steak & Greens',
    description: 'High protein, low carb dinner to hit your targets.',
    calories: 620,
    protein: 45,
    carbs: 8,
    fats: 32,
    icon: Icons.restaurant_rounded,
    color: const Color(0xFFE91E63),
  ),
  DietPlan(
    name: 'Salmon Quinoa Bowl',
    description: 'Rich in Omega-3 and complex carbs for recovery.',
    calories: 580,
    protein: 38,
    carbs: 45,
    fats: 22,
    icon: Icons.set_meal_rounded,
    color: const Color(0xFF2196F3),
  ),
  DietPlan(
    name: 'Greek Yogurt Parfait',
    description: 'Quick protein-packed snack to bridge the gap.',
    calories: 320,
    protein: 25,
    carbs: 35,
    fats: 8,
    icon: Icons.icecream_rounded,
    color: const Color(0xFF4CAF50),
  ),
];
