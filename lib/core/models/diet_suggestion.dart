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
    return SuggestedMealItem(
      name: json['name'] as String,
      purpose: json['purpose'] as String,
      calories: json['calories'] as int,
      protein: json['protein'] as int,
      carbs: json['carbs'] as int,
      fat: json['fat'] as int,
      fiber: json['fiber'] as int,
    );
  }
}
