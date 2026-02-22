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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Decorative Background
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.fitness_center_rounded,
                size: 120,
                color: HeracleTheme.bgBlue.withValues(alpha: 0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF94B600).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 12,
                              color: Color(0xFF94B600),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'AI SUGGESTED',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF94B600),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.more_horiz_rounded,
                        color: HeracleTheme.fadedText,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    session.title,
                    style: const TextStyle(
                      color: HeracleTheme.textBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (session.content != null && session.content!.isNotEmpty)
                    Text(
                      session.content!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: HeracleTheme.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Thumbnails
                      if (session.exercises.isNotEmpty)
                        SizedBox(
                          height: 28,
                          width: 60,
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
                                  left: i * 14.0,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      color: HeracleTheme.bgBlue,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: session.exercises[i].image != null
                                          ? Image.network(
                                              session.exercises[i].image!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons
                                                        .fitness_center_rounded,
                                                    size: 14,
                                                    color: HeracleTheme
                                                        .primaryPurple,
                                                  ),
                                            )
                                          : const Icon(
                                              Icons.fitness_center_rounded,
                                              size: 14,
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
                        '${session.exercisesCount} Exercises',
                        style: const TextStyle(
                          color: HeracleTheme.textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: onViewSession,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HeracleTheme.textBlack,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'View',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios_rounded, size: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
