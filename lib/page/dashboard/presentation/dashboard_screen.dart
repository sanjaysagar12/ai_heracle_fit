import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/page/dashboard/widgets/bottom_chat_bar.dart';
import 'package:ai_heracle_fit/page/dashboard/tabs/home_tab.dart';
import 'package:ai_heracle_fit/page/dashboard/tabs/ai_tab.dart';
import 'package:ai_heracle_fit/page/dashboard/repository/ai_repository.dart';
import 'package:ai_heracle_fit/core/models/ai_response.dart';
import 'package:ai_heracle_fit/core/models/workout_session.dart';
import 'package:ai_heracle_fit/page/dashboard/tabs/exercise_detail_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final FocusNode _chatFocusNode = FocusNode();
  final TextEditingController _chatController = TextEditingController();
  final AiRepository _aiRepository = AiRepository();

  final List<Object> _messages = []; // Can be String (User) or AiResponse (AI)
  bool _isLoading = false;
  WorkoutSession? _selectedSession;

  @override
  void initState() {
    super.initState();
    _chatFocusNode.addListener(() {
      if (_chatFocusNode.hasFocus && _selectedIndex == 0) {
        setState(() {
          _selectedIndex = 1;
        });
      }
    });

    // Add initial AI message
    _messages.add(
      AiResponse(
        type: AiResponseType.reply,
        message: 'Hello! How can I help you today?',
      ),
    );
  }

  @override
  void dispose() {
    _chatFocusNode.dispose();
    _chatController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _selectedSession = null;
      }
    });
    if (index == 0) {
      _chatFocusNode.unfocus();
    }
  }

  Future<void> _handleSend() async {
    final text = _chatController.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(text);
      _chatController.clear();
      _isLoading = true;
      if (_selectedIndex != 1) {
        _selectedIndex = 1;
      }
    });

    try {
      final response = await _aiRepository.sendMessage(text);
      if (mounted) {
        setState(() {
          _messages.add(response);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onViewWorkout(WorkoutSession session) {
    setState(() {
      _selectedSession = session;
    });
  }

  @override
  Widget build(BuildContext context) {
    const int slideDuration = 800;
    const Curve animationCurve = Curves.easeInOutCubic;
    final bool isChatVisible = _selectedIndex == 1;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HeracleTheme.bgPink,
                    Colors.white,
                    HeracleTheme.bgBlue,
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
            // Content
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: AnimatedSlide(
                            offset: isChatVisible
                                ? const Offset(0, -0.5)
                                : Offset.zero,
                            duration: const Duration(
                              milliseconds: slideDuration,
                            ),
                            curve: animationCurve,
                            child: Column(
                              children: [
                                // Tab 1: Home Dashboard
                                SizedBox(
                                  height: constraints.maxHeight,
                                  child: const HomeTab(),
                                ),
                                // Tab 2: AI Interface / Exercise Detail
                                SizedBox(
                                  height: constraints.maxHeight,
                                  child: _selectedSession != null
                                      ? ExerciseDetailTab(
                                          session: _selectedSession!,
                                          onBack: () => setState(
                                            () => _selectedSession = null,
                                          ),
                                        )
                                      : AiTab(
                                          messages: _messages,
                                          onClose: () => _onItemTapped(0),
                                          onViewWorkout: _onViewWorkout,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Pinned Chat Bar
                  BottomChatBar(
                    focusNode: _chatFocusNode,
                    controller: _chatController,
                    onSend: _handleSend,
                    isActive: isChatVisible,
                    isLoading: _isLoading,
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
