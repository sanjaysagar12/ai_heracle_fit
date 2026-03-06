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
    int toInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      return 0;
    }

    return TrackedFood(
      name: json['name'] as String? ?? 'Unknown Food',
      calories: toInt(json['calories']),
      protein: toInt(json['protein']),
      carbs: toInt(json['carbs']),
      fats: toInt(json['fats'] ?? json['fat']),
      fiber: toInt(json['fiber']),
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
