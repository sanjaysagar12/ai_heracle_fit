import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/workout_session.dart';

class ExerciseDetailTab extends StatelessWidget {
  final WorkoutSession session;
  final VoidCallback onBack;

  const ExerciseDetailTab({
    super.key,
    required this.session,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  color: HeracleTheme.textBlack,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: HeracleTheme.textBlack,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        '${session.exercisesCount} Exercises • ${session.category ?? "Workout"}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: HeracleTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          // Exercise List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: session.exercises.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final exercise = session.exercises[index];
                return _buildExerciseCard(exercise);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Image & Name
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: HeracleTheme.bgBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: exercise.image != null
                        ? Image.network(
                            exercise.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.fitness_center_rounded,
                                  color: HeracleTheme.primaryPurple,
                                  size: 30,
                                ),
                          )
                        : const Icon(
                            Icons.fitness_center_rounded,
                            color: HeracleTheme.primaryPurple,
                            size: 30,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: HeracleTheme.textBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exercise.desc ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: HeracleTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          // Sets
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: exercise.sets.asMap().entries.map((entry) {
                final setIndex = entry.key + 1;
                final setData = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SET $setIndex',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          color: HeracleTheme.textGrey,
                        ),
                      ),
                      Row(
                        children: [
                          _buildSetMetric('${setData.kg} kg'),
                          const SizedBox(width: 16),
                          _buildSetMetric('${setData.reps} reps'),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetMetric(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: HeracleTheme.bgPink.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: HeracleTheme.textBlack,
        ),
      ),
    );
  }
}
