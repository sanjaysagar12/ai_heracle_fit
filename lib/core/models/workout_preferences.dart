class WorkoutPreferences {
  final String fitnessLevel; // beginner | intermediate | advanced
  final int workoutFrequencyPerWeek; // 1–7
  final String preferredWorkoutType; // strength | cardio | flexibility | mixed
  final String? injuries; // optional free text
  final List<String> availableDays; // monday … sunday
  final String preferredWorkoutTime; // morning | afternoon | evening
  final int sessionDurationMins; // 15 | 30 | 45 | 60 | 90

  const WorkoutPreferences({
    required this.fitnessLevel,
    required this.workoutFrequencyPerWeek,
    required this.preferredWorkoutType,
    this.injuries,
    required this.availableDays,
    required this.preferredWorkoutTime,
    required this.sessionDurationMins,
  });

  Map<String, dynamic> toJson() => {
    'fitnessLevel': fitnessLevel,
    'workoutFrequencyPerWeek': workoutFrequencyPerWeek,
    'preferredWorkoutType': preferredWorkoutType,
    if (injuries != null && injuries!.isNotEmpty) 'injuries': injuries,
    'availableDays': availableDays,
    'preferredWorkoutTime': preferredWorkoutTime,
    'sessionDurationMins': sessionDurationMins,
  };
}
