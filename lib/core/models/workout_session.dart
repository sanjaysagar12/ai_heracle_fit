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
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      category: json['category'] as String?,
      exercisesCount: json['exercisesCount'] as int,
      position: json['position'] as int?,
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
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
      id: json['id'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String?,
      image: json['image'] as String?,
      sets: (json['sets'] as List)
          .map((e) => ExerciseSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExerciseSet {
  final double kg;
  final int reps;

  ExerciseSet({required this.kg, required this.reps});

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      kg: (json['kg'] as num).toDouble(),
      reps: json['reps'] as int,
    );
  }
}
