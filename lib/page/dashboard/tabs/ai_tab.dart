import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';

class AiTab extends StatelessWidget {
  final VoidCallback onClose;

  const AiTab({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Solid background for slide-up
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Minimalist Top-of-Page Chat Header
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF94B600),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'HERACLE AI',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: HeracleTheme.textBlack,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: onClose,
                    style: TextButton.styleFrom(
                      foregroundColor: HeracleTheme.textGrey,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  _buildMessageBubble(
                    'Hello! How can I help you today?',
                    isAi: true,
                  ),
                  _buildMessageBubble(
                    'I want to focus on my biceps today.',
                    isAi: false,
                  ),
                  _buildMessageBubble(
                    'Great! I\'ve updated your recommended muscle card. We\'ll focus on curls and pull-ups.',
                    isAi: true,
                  ),
                  _buildMessageBubble(
                    'I can also suggest a diet plan to complement this workout. Are you interested?',
                    isAi: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(String text, {required bool isAi}) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isAi ? Colors.white : const Color(0xFF94B600),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isAi ? 0.02 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: isAi
              ? Border.all(color: Colors.black.withOpacity(0.05), width: 1)
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isAi ? HeracleTheme.textBlack : Colors.white,
            fontSize: 15,
            height: 1.5,
            fontWeight: isAi ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
