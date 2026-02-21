import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/page/dashboard/widgets/bottom_chat_bar.dart';
import 'package:ai_heracle_fit/page/dashboard/tabs/home_tab.dart';
import 'package:ai_heracle_fit/page/dashboard/tabs/ai_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final FocusNode _chatFocusNode = FocusNode();

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
  }

  @override
  void dispose() {
    _chatFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _chatFocusNode.unfocus();
    }
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
                                // Tab 2: AI Interface
                                SizedBox(
                                  height: constraints.maxHeight,
                                  child: AiTab(onClose: () => _onItemTapped(0)),
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
                    isActive: isChatVisible,
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
