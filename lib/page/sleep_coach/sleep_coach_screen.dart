import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/page/sleep_coach/sleep_data_model.dart';

class SleepCoachScreen extends StatelessWidget {
  const SleepCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAiInsightCard(),
                        const SizedBox(height: 33),
                        const Text(
                          'Sleep Quality',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: HeracleTheme.textBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your sleep patterns over the last 7 days.',
                          style: TextStyle(
                            fontSize: 14,
                            color: HeracleTheme.textGrey.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSleepGraph(),
                        const SizedBox(height: 32),
                        const Text(
                          'AI Coaching Tips',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: HeracleTheme.textBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...mockSleepTips.map((tip) => _buildTipCard(tip)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: HeracleTheme.textBlack,
          ),
          const SizedBox(width: 8),
          const Text(
            'Sleep Coach',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: HeracleTheme.textBlack,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: HeracleTheme.givingliYellow.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: HeracleTheme.givingliYellowDark,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsightCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1B20),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.bedtime_rounded,
              size: 140,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: HeracleTheme.givingliYellowDark.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: HeracleTheme.givingliYellowDark.withOpacity(
                            0.3,
                          ),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            size: 14,
                            color: HeracleTheme.givingliYellowDark,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'AI INSIGHT',
                            style: TextStyle(
                              color: HeracleTheme.givingliYellowDark,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Great recovery last night! Your deep sleep was 15% higher than your average, which is perfect for muscle repair.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildSleepStat('8h 12m', 'Duration'),
                    const SizedBox(width: 40),
                    _buildSleepStat('92%', 'Quality'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepGraph() {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Y-Axis Labels
                SizedBox(
                  width: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['10h', '7.5h', '5h', '2.5h', '0h']
                        .map(
                          (label) => Text(
                            label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: HeracleTheme.textGrey.withOpacity(0.5),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 12),
                // Graph Area
                Expanded(
                  child: Stack(
                    children: [
                      // Grid Lines
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          5,
                          (_) => Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.03),
                          ),
                        ),
                      ),
                      // Bars
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: mockSleepHistory.map((data) {
                            double heightFactor = data.hours / 10.0;
                            bool isSelected = data.day == 'Wed';

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Value tooltip-like text
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? HeracleTheme.textBlack
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${data.hours}h',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected
                                              ? Colors.white
                                              : HeracleTheme.textGrey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // The Bar
                                    Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxWidth: 32,
                                      ),
                                      height: 150 * heightFactor,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            HeracleTheme.givingliYellowDark,
                                            HeracleTheme.givingliYellowDark
                                                .withOpacity(
                                                  isSelected ? 0.9 : 0.6,
                                                ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          if (isSelected)
                                            BoxShadow(
                                              color: HeracleTheme
                                                  .givingliYellowDark
                                                  .withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // X-Axis Day Labels
          Padding(
            padding: const EdgeInsets.only(left: 42), // Offset for Y-axis
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: mockSleepHistory.map((data) {
                bool isSelected = data.day == 'Wed';
                return Expanded(
                  child: Center(
                    child: Text(
                      data.day,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w900
                            : FontWeight.w600,
                        color: isSelected
                            ? HeracleTheme.textBlack
                            : HeracleTheme.textGrey.withOpacity(0.6),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(SleepTip tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: tip.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(tip.icon, color: tip.color, size: 26),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: HeracleTheme.textBlack,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tip.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: HeracleTheme.textGrey.withOpacity(0.85),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
