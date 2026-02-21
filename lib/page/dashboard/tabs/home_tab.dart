import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/page/dashboard/widgets/header_widget.dart';
import 'package:ai_heracle_fit/page/dashboard/widgets/greeting_widget.dart';
import 'package:ai_heracle_fit/page/dashboard/widgets/ai_cards_section.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              8, // Reduced top padding
              20,
              0,
            ),
            child: HeaderWidget(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12, // Reduced top padding
              20,
              12, // Reduced bottom padding
            ),
            child: GreetingWidget(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [AiCardsSection(), SizedBox(height: 32)]),
          ),
        ],
      ),
    );
  }
}
