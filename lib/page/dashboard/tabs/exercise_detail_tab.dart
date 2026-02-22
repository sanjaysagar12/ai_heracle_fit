import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/workout_session.dart';

class ExerciseDetailTab extends StatefulWidget {
  final WorkoutSession session;
  final VoidCallback onBack;

  const ExerciseDetailTab({
    super.key,
    required this.session,
    required this.onBack,
  });

  @override
  State<ExerciseDetailTab> createState() => _ExerciseDetailTabState();
}

class _ExerciseDetailTabState extends State<ExerciseDetailTab> {
  bool _isCopying = false;

  Future<void> _handleCopySession() async {
    setState(() {
      _isCopying = true;
    });

    // Mocking the copy logic
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isCopying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Session copied: ${widget.session.title}'),
          backgroundColor: HeracleTheme.primaryPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _handleFinishWorkout() async {
    // Mocking the finish logic
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Workout Finished! Streak updated.'),
          backgroundColor: HeracleTheme.primaryPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Inherit DashboardScreen gradient
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                    color: HeracleTheme.textBlack,
                  ),
                ),
                Text(
                  widget.session.title,
                  style: const TextStyle(
                    color: HeracleTheme.textBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x1F000000)),
          // Exercise List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                140,
              ), // Space for FABs
              itemCount: widget.session.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.session.exercises[index];
                return _buildExerciseCard(exercise);
              },
            ),
          ),
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            onPressed: _isCopying ? null : _handleCopySession,
            icon: _isCopying
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.copy_rounded, color: Colors.white, size: 20),
            label: _isCopying ? 'Copying...' : 'Copy Session',
            backgroundColor: HeracleTheme.textBlack,
            labelColor: Colors.white,
          ),
          const SizedBox(height: 12),
          _buildButton(
            onPressed: _handleFinishWorkout,
            icon: const Icon(
              Icons.check_circle_rounded,
              color: HeracleTheme.textBlack,
              size: 20,
            ),
            label: 'Finish Workout',
            backgroundColor: HeracleTheme.primaryPurple,
            labelColor: HeracleTheme.textBlack,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
    required Color backgroundColor,
    required Color labelColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Light theme card
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HeracleTheme.bgBlue,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: exercise.image != null
                      ? Image.network(
                          exercise.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.fitness_center_rounded,
                                color: HeracleTheme.primaryPurple,
                              ),
                        )
                      : const Icon(
                          Icons.fitness_center_rounded,
                          color: HeracleTheme.primaryPurple,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        color: HeracleTheme.textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (exercise.desc != null && exercise.desc!.isNotEmpty)
                      Text(
                        exercise.desc!,
                        style: const TextStyle(
                          color: HeracleTheme.textGrey,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.more_horiz_rounded,
                color: HeracleTheme.fadedText,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...exercise.sets.asMap().entries.map((entry) {
            final index = entry.key;
            final set = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      'Set ${index + 1}',
                      style: const TextStyle(
                        color: HeracleTheme.givingliGreenDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildSetParam('Weight', '${set.kg} kg'),
                  const SizedBox(width: 24),
                  _buildSetParam('Reps', '${set.reps}'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSetParam(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: HeracleTheme.textGrey, fontSize: 13),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: HeracleTheme.bgBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          constraints: const BoxConstraints(minWidth: 40),
          alignment: Alignment.center,
          child: Text(
            value,
            style: const TextStyle(
              color: HeracleTheme.textBlack,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
