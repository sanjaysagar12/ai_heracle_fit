class TrackedFood {
  String name;
  int calories;
  int protein;
  int carbs;
  int fats;
  int fiber;
  String mealType;
  double quantity;

  // Base values per unit (quantity = 1.0)
  int baseCalories;
  int baseProtein;
  int baseCarbs;
  int baseFats;
  int baseFiber;

  TrackedFood({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
    this.mealType = 'Other',
    this.quantity = 1.0,
    int? baseCalories,
    int? baseProtein,
    int? baseCarbs,
    int? baseFats,
    int? baseFiber,
  }) : baseCalories = baseCalories ?? calories,
       baseProtein = baseProtein ?? protein,
       baseCarbs = baseCarbs ?? carbs,
       baseFats = baseFats ?? fats,
       baseFiber = baseFiber ?? fiber;

  factory TrackedFood.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      return 0;
    }

    final int calories = toInt(json['calories']);
    final int protein = toInt(json['protein']);
    final int carbs = toInt(json['carbs']);
    final int fats = toInt(json['fats'] ?? json['fat']);
    final int fiber = toInt(json['fiber']);
    final double quantity = (json['quantity'] as num?)?.toDouble() ?? 1.0;

    return TrackedFood(
      name: json['name'] as String? ?? 'Unknown Food',
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      fiber: fiber,
      mealType: json['mealType'] as String? ?? 'Other',
      quantity: quantity,
      baseCalories: toInt(json['baseCalories'] ?? calories),
      baseProtein: toInt(json['baseProtein'] ?? protein),
      baseCarbs: toInt(json['baseCarbs'] ?? carbs),
      baseFats: toInt(json['baseFats'] ?? json['baseFat'] ?? fats),
      baseFiber: toInt(json['baseFiber'] ?? fiber),
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
      'quantity': quantity,
      'baseCalories': baseCalories,
      'baseProtein': baseProtein,
      'baseCarbs': baseCarbs,
      'baseFats': baseFats,
      'baseFiber': baseFiber,
    };
  }

  void updateQuantity(double newQuantity) {
    quantity = newQuantity;
    calories = (baseCalories * quantity).round();
    protein = (baseProtein * quantity).round();
    carbs = (baseCarbs * quantity).round();
    fats = (baseFats * quantity).round();
    fiber = (baseFiber * quantity).round();

    // Update name to include quantity suffix (e.g. "Apple x2")
    // First, strip any existing " xN" suffix
    String baseName = name.replaceAll(RegExp(r' x\d+(\.\d+)?$'), '');
    if (quantity > 1) {
      name = '$baseName x${quantity.toInt()}';
    } else {
      name = baseName;
    }
  }
}
