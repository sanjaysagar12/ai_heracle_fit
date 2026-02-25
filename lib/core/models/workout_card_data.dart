class ExerciseSet {
  final int kg;
  final int reps;

  const ExerciseSet({required this.kg, required this.reps});

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
    kg: (json['kg'] as num?)?.toInt() ?? 0,
    reps: (json['reps'] as num?)?.toInt() ?? 0,
  );
}

class WorkoutExercise {
  final String id;
  final String name;
  final String desc;
  final String? image;
  final List<ExerciseSet> sets;

  const WorkoutExercise({
    required this.id,
    required this.name,
    required this.desc,
    this.image,
    required this.sets,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      WorkoutExercise(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        desc: json['desc'] as String? ?? '',
        image: json['image'] as String?,
        sets: (json['sets'] as List<dynamic>? ?? [])
            .map(
              (s) => ExerciseSet.fromJson(Map<String, dynamic>.from(s as Map)),
            )
            .toList(),
      );
}

class WorkoutSession {
  final String id;
  final String title;
  final String content;
  final String category;
  final int exercisesCount;
  final int position;
  final List<WorkoutExercise> exercises;

  const WorkoutSession({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.exercisesCount,
    required this.position,
    required this.exercises,
  });

  factory WorkoutSession.fromJson(Map<String, dynamic> json) => WorkoutSession(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    content: json['content'] as String? ?? '',
    category: json['category'] as String? ?? '',
    exercisesCount: (json['exercisesCount'] as num?)?.toInt() ?? 0,
    position: (json['position'] as num?)?.toInt() ?? 0,
    exercises: (json['exercises'] as List<dynamic>? ?? [])
        .map(
          (e) => WorkoutExercise.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList(),
  );
}

/// Full data that drives the hero "focus" card + session list on the dashboard.
class WorkoutCardData {
  final String title;
  final String highlight;
  final String subtext;
  final String buttonLabel;

  /// Raw duration in minutes from the API (null = new user).
  final int? durationMinutes;

  final String? intensity;
  final List<WorkoutSession> sessions;

  const WorkoutCardData({
    required this.title,
    required this.highlight,
    required this.subtext,
    this.buttonLabel = 'View more',
    this.durationMinutes,
    this.intensity,
    this.sessions = const [],
  });

  /// Formatted duration string, e.g. "45M". Null when no data.
  String? get durationLabel =>
      durationMinutes != null ? '${durationMinutes}M' : null;

  /// Intensity label, title-cased, e.g. "Hard".
  String? get intensityLabel => intensity != null
      ? '${intensity![0].toUpperCase()}${intensity!.substring(1).toLowerCase()}'
      : null;

  bool get hasChips => durationLabel != null && intensityLabel != null;
  bool get isNewUser => sessions.isEmpty && durationMinutes == null;

  factory WorkoutCardData.fromJson(Map<String, dynamic> json) =>
      WorkoutCardData(
        title: json['title'] as String? ?? 'Suggested\nMuscle',
        highlight: json['highlight'] as String? ?? '',
        subtext: json['subtext'] as String? ?? '',
        durationMinutes: (json['duration'] as num?)?.toInt(),
        intensity: json['intensity'] as String?,
        sessions: (json['session'] as List<dynamic>? ?? [])
            .map(
              (s) =>
                  WorkoutSession.fromJson(Map<String, dynamic>.from(s as Map)),
            )
            .toList(),
      );

  /// Shown for a brand-new user who has no workout history yet.
  static const newUser = WorkoutCardData(
    title: 'Your\nFocus',
    highlight: "Let's get started",
    subtext: 'Tell us your goal to personalise',
    buttonLabel: 'Set Goal',
    durationMinutes: null, // No real data
    intensity: null, // No real data
  );

  /// Chip labels for new-user onboarding placeholders.
  String? get chipDuration => isNewUser ? 'Beginner' : durationLabel;
  String? get chipIntensity => isNewUser ? 'Start' : intensityLabel;
}
