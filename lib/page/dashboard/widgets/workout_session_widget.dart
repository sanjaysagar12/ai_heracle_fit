import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/workout_session.dart';

class WorkoutSessionWidget extends StatelessWidget {
  final WorkoutSession session;
  final VoidCallback onViewSession;

  const WorkoutSessionWidget({
    super.key,
    required this.session,
    required this.onViewSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HeracleTheme.textBlack,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  session.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const Icon(
                Icons.more_horiz_rounded,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            session.content ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Thumbnails
              if (session.exercises.isNotEmpty)
                SizedBox(
                  height: 24,
                  width: 50,
                  child: Stack(
                    children: [
                      for (
                        int i = 0;
                        i <
                            (session.exercises.length > 3
                                ? 3
                                : session.exercises.length);
                        i++
                      )
                        Positioned(
                          left: i * 12.0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: HeracleTheme.textBlack,
                                width: 2,
                              ),
                              color: HeracleTheme.bgBlue,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: session.exercises[i].image != null
                                  ? Image.network(
                                      session.exercises[i].image!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.fitness_center_rounded,
                                                size: 10,
                                                color:
                                                    HeracleTheme.primaryPurple,
                                              ),
                                    )
                                  : const Icon(
                                      Icons.fitness_center_rounded,
                                      size: 10,
                                      color: HeracleTheme.primaryPurple,
                                    ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                '${session.exercisesCount}+ items',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: onViewSession,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: HeracleTheme.primaryPurple.withOpacity(0.5),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    foregroundColor: HeracleTheme.primaryPurple,
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
