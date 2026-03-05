class BodyMetrics {
  final int age;
  final String gender; // male | female | other
  final double heightCm;
  final double heightFt;
  final double weightKg;
  final double weightLbs;
  final String bodyType; // ectomorph | mesomorph | endomorph
  final String
  goal; // muscle_gain | fat_loss | endurance | flexibility | general_fitness
  final double goalWeightKg;
  final double goalWeightLbs;

  const BodyMetrics({
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.heightFt,
    required this.weightKg,
    required this.weightLbs,
    required this.bodyType,
    required this.goal,
    required this.goalWeightKg,
    required this.goalWeightLbs,
  });

  Map<String, dynamic> toJson() => {
    'age': age,
    'gender': gender,
    'heightCm': heightCm,
    'heightFt': double.parse(heightFt.toStringAsFixed(1)),
    'weightKg': weightKg,
    'weightLbs': double.parse(weightLbs.toStringAsFixed(1)),
    'bodyType': bodyType,
    'goal': goal,
    'goalWeightKg': goalWeightKg,
    'goalWeightLbs': double.parse(goalWeightLbs.toStringAsFixed(1)),
  };

  /// Converts cm ↔ ft helpers
  static double cmToFt(double cm) =>
      double.parse((cm / 30.48).toStringAsFixed(1));
  static double kgToLbs(double kg) =>
      double.parse((kg * 2.20462).toStringAsFixed(1));
}
