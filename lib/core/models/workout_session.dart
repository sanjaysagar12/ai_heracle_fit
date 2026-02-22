class WorkoutSession {
  final String id;
  final String title;
  final String? content;
  final String? category;
  final int exercisesCount;
  final int? position;
  final List<Exercise> exercises;
  final DateTime createdAt;

  WorkoutSession({
    required this.id,
    required this.title,
    this.content,
    this.category,
    required this.exercisesCount,
    this.position,
    required this.exercises,
    required this.createdAt,
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title']?.toString() ?? 'Workout Session',
      content: json['content']?.toString(),
      category: json['category']?.toString(),
      exercisesCount:
          int.tryParse(json['exercisesCount']?.toString() ?? '0') ??
          (json['exercises'] as List?)?.length ??
          0,
      position: int.tryParse(json['position']?.toString() ?? '0'),
      exercises: json['exercises'] != null
          ? (json['exercises'] as List)
                .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class Exercise {
  final String id;
  final String name;
  final String? desc;
  final String? image;
  final List<ExerciseSet> sets;

  Exercise({
    required this.id,
    required this.name,
    this.desc,
    this.image,
    required this.sets,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name']?.toString() ?? 'Unknown Exercise',
      desc: json['desc']?.toString(),
      image: json['image']?.toString(),
      sets: json['sets'] != null
          ? (json['sets'] as List)
                .map((e) => ExerciseSet.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}

class ExerciseSet {
  final double kg;
  final int reps;

  ExerciseSet({required this.kg, required this.reps});

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      kg: double.tryParse(json['kg']?.toString() ?? '0') ?? 0.0,
      reps: int.tryParse(json['reps']?.toString() ?? '0') ?? 0,
    );
  }
}
