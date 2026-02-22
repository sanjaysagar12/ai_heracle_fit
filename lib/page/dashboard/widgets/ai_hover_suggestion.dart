import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/services/suggestion_service.dart';

class AiHoverSuggestion extends StatefulWidget {
  const AiHoverSuggestion({super.key});

  @override
  State<AiHoverSuggestion> createState() => _AiHoverSuggestionState();
}

class _AiHoverSuggestionState extends State<AiHoverSuggestion> {
  final SuggestionService _suggestionService = SuggestionService();
  Suggestion? _suggestion;
  bool _isVisible = false;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestion();
  }

  Future<void> _loadSuggestion() async {
    final suggestion = await _suggestionService.getContextualSuggestion();
    if (mounted) {
      setState(() {
        _suggestion = suggestion;
        // Delay visibility for a nice entrance effect
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _isVisible = true);
        });
      });
    }
  }

  void _dismiss() {
    setState(() => _isVisible = false);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isDismissed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_suggestion == null || _isDismissed) return const SizedBox.shrink();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _isVisible ? 1.0 : 0.0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 500),
        scale: _isVisible ? 1.0 : 0.8,
        curve: _isVisible ? Curves.easeOutBack : Curves.easeInBack,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 500),
          curve: _isVisible ? Curves.easeOutCubic : Curves.easeInCubic,
          offset: _isVisible ? Offset.zero : const Offset(0, 0.1),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF94B600).withOpacity(0.12),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8),
                  BlendMode.srcOver,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF94B600).withOpacity(0.15),
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF94B600).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Color(0xFF94B600),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'HERACLE INSIGHT',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF94B600),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _suggestion!.message,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: HeracleTheme.textBlack,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Action for view session
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF94B600),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _suggestion!.actionLabel,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_rounded, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: -12,
                        top: -12,
                        child: IconButton(
                          onPressed: _dismiss,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: HeracleTheme.textGrey,
                            size: 20,
                          ),
                          splashRadius: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
