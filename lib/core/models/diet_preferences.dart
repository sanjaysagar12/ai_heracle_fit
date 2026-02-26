class DietPreferences {
  final String
  dietaryPreference; // vegan | vegetarian | keto | paleo | omnivore | gluten_free
  final double dailyWaterLitres; // e.g. 2.5
  final int mealsPerDay; // 2 | 3 | 4 | 5 | 6

  const DietPreferences({
    required this.dietaryPreference,
    required this.dailyWaterLitres,
    required this.mealsPerDay,
  });

  Map<String, dynamic> toJson() => {
    'dietaryPreference': dietaryPreference,
    'dailyWaterLitres': dailyWaterLitres,
    'mealsPerDay': mealsPerDay,
  };
}
