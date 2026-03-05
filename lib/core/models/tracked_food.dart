class TrackedFood {
  String name;
  int calories;
  int protein;
  int carbs;
  int fats;
  int fiber;
  String mealType;

  TrackedFood({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
    this.mealType = 'Other',
  });

  factory TrackedFood.fromJson(Map<String, dynamic> json) {
    return TrackedFood(
      name: json['name'] as String? ?? 'Unknown Food',
      calories: json['calories'] as int? ?? 0,
      protein: json['protein'] as int? ?? 0,
      carbs: json['carbs'] as int? ?? 0,
      fats:
          (json['fats'] ?? json['fat']) as int? ??
          0, // Handle both 'fats' and 'fat'
      fiber: json['fiber'] as int? ?? 0,
      mealType: json['mealType'] as String? ?? 'Other',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'mealType': mealType,
    };
  }
}
