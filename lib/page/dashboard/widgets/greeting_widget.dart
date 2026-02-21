import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({super.key});

  @override
  State<GreetingWidget> createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  static const String _fullText =
      'Good morning! Your circadian rhythm is as wonderful as your soul, guiding you through the day with energy and purpose...';

  String _currentText = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    int index = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (index < _fullText.length) {
        setState(() {
          _currentText += _fullText[index];
          index++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 20,
              color: HeracleTheme.textBlack,
              fontWeight: FontWeight.w400, // Entire text is now semi-bold/bold
              height: 1.3,
              letterSpacing: -0.5,
            ),
            children: [TextSpan(text: _currentText)],
          ),
        ),
      ],
    );
  }
}
