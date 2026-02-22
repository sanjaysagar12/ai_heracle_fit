import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/ai_response.dart';
import 'package:ai_heracle_fit/page/dashboard/widgets/workout_session_widget.dart';
import 'package:ai_heracle_fit/core/models/workout_session.dart';

class AiTab extends StatefulWidget {
  final List<Object> messages;
  final VoidCallback onClose;
  final Function(WorkoutSession) onViewWorkout;

  const AiTab({
    super.key,
    required this.messages,
    required this.onClose,
    required this.onViewWorkout,
  });

  @override
  State<AiTab> createState() => _AiTabState();
}

class _AiTabState extends State<AiTab> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(AiTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // App theme background
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF94B600), // Team's improved green
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
                  onPressed: widget.onClose,
                  style: TextButton.styleFrom(
                    foregroundColor: HeracleTheme.textGrey,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text(
                    'Close',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.messages[index];
                if (msg is String) {
                  return _buildUserMessage(msg);
                } else if (msg is AiResponse) {
                  if (msg.type == AiResponseType.workout && msg.data != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAiMessage(msg.message),
                        ...msg.data!.map(
                          (session) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: WorkoutSessionWidget(
                              session: session,
                              onViewSession: () =>
                                  widget.onViewWorkout(session),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return _buildAiMessage(msg.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: HeracleTheme.textBlack,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildAiMessage(String text) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: const Color(0xFF94B600), // Team's improved green
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(color: HeracleTheme.textBlack, fontSize: 14),
        ),
      ),
    );
  }
}
