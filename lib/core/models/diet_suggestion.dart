class DietSuggestion {
  final String id;
  final String suggestion;
  final List<SuggestedMealItem> suggestedMeal;
  final String date;
  final DateTime createdAt;

  DietSuggestion({
    required this.id,
    required this.suggestion,
    required this.suggestedMeal,
    required this.date,
    required this.createdAt,
  });

  factory DietSuggestion.fromJson(Map<String, dynamic> json) {
    return DietSuggestion(
      id: json['id'] as String,
      suggestion: json['suggestion'] as String,
      suggestedMeal: (json['suggestedMeal'] as List)
          .map((e) => SuggestedMealItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: json['date'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class SuggestedMealItem {
  final String name;
  final String purpose;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;

  SuggestedMealItem({
    required this.name,
    required this.purpose,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });

  factory SuggestedMealItem.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      return 0;
    }

    return SuggestedMealItem(
      name: json['name'] as String? ?? 'Unknown',
      purpose: json['purpose'] as String? ?? 'General',
      calories: toInt(json['calories']),
      protein: toInt(json['protein']),
      carbs: toInt(json['carbs']),
      fat: toInt(json['fat']),
      fiber: toInt(json['fiber']),
    );
  }
}
