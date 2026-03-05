class MacroData {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  MacroData({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });

  factory MacroData.fromJson(Map<String, dynamic> json) {
    return MacroData(
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DietStatus {
  final MacroData targets;
  final MacroData consumed;

  DietStatus({required this.targets, required this.consumed});

  factory DietStatus.fromJson(Map<String, dynamic> json) {
    return DietStatus(
      targets: MacroData.fromJson(json['targets'] as Map<String, dynamic>),
      consumed: MacroData.fromJson(json['consumed'] as Map<String, dynamic>),
    );
  }
}
