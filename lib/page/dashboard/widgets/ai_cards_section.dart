import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';

class AiCardsSection extends StatelessWidget {
  const AiCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Card: Suggested Muscle (Deep Professional Indigo)
            Expanded(
              flex: 5,
              child: _buildProfessionalHeroCard(
                title: 'Suggested\nMuscle',
                highlight: 'Biceps & Back',
                subtext: 'Optimal for hypertrophy',
                icon: Icons.fitness_center_rounded,
                primaryColor: const Color(0xFF1A1F2C), // Sleek Charcoal Navy
                accentColor: const Color(0xFF7B61FF), // Glowing Indigo
              ),
            ),
            const SizedBox(width: 16),
            // Side Modules: Diet and Sleep (Sleek Professional White)
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  _buildProfessionalSmallCard(
                    title: 'Diet Planning',
                    subtitle: 'Keto-Focused Plan',
                    icon: Icons.restaurant_rounded,
                    iconBg: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF2E7D32),
                    tag: 'AI Plan',
                  ),
                  const SizedBox(height: 16),
                  _buildProfessionalSmallCard(
                    title: 'Sleep Coach',
                    subtitle: 'Circadian Rhythm',
                    icon: Icons.bedtime_rounded,
                    iconBg: const Color(0xFFFFF3E0),
                    iconColor: const Color(0xFFE65100),
                    tag: '8h 12m',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const ProgressCard(),
      ],
    );
  }

  Widget _buildProfessionalHeroCard({
    required String title,
    required String highlight,
    required String subtext,
    required IconData icon,
    required Color primaryColor,
    required Color accentColor,
  }) {
    return Container(
      height: 300, // Reduced from 320 to prevent overflow
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Abstract background icon
            Positioned(
              bottom: -20,
              left: -30,
              child: Icon(
                icon,
                size: 220,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
            // Glowing mesh effect
            Positioned(
              top: -60,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [accentColor.withOpacity(0.2), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(22), // Slightly reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Status/Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 12,
                                color: accentColor,
                              ),
                              const SizedBox(width: 4),
                              const Flexible(
                                child: Text(
                                  'AI SUGGESTION',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8, // Reduced font size
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        icon,
                        color: Colors.white.withOpacity(0.2),
                        size: 20, // Reduced icon size
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Reduced from 30
                  // Main Content Area
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24, // Reduced from 26
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced from 10
                  // Focus Highlight with accent line
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 14,
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          highlight,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14, // Reduced from 15
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtext,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11, // Reduced from 12
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 10), // Reduced from 12
                  // Metadata Chips
                  Row(
                    children: [
                      _buildMiniChip(Icons.timer_outlined, '45M', accentColor),
                      const SizedBox(width: 8),
                      _buildMiniChip(
                        Icons.flash_on_rounded,
                        'High',
                        accentColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Reduced from 12
                  // Action Button
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 50, // Reduced from 46
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accentColor, accentColor.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View more',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalSmallCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    String? tag,
  }) {
    return Container(
      height: 142,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.04), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Decorative Background Icon
            Positioned(
              right: -15,
              bottom: -15,
              child: Icon(icon, size: 100, color: iconColor.withOpacity(0.05)),
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconBg,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: iconColor.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: iconColor, size: 20),
                      ),
                      if (tag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: iconBg.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: iconColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: HeracleTheme.textBlack,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: HeracleTheme.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: Colors.black.withOpacity(0.2),
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

class ProgressCard extends StatefulWidget {
  const ProgressCard({super.key});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedMuscle = 'Chest';
  String _selectedDietMetric = 'Calories';

  final List<String> _muscles = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
  ];

  final List<String> _dietMetrics = [
    'Calories',
    'Protein',
    'Carbs',
    'Fats',
  ];

  @override
  Widget build(BuildContext context) {
    bool isMusclePage = _currentPage == 0;
    
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background Mesh/Glow
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (isMusclePage
                              ? const Color(0xFF7B61FF)
                              : Colors.orange)
                          .withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMusclePage
                                ? 'Muscle Progress'
                                : 'Diet Progress',
                            style: const TextStyle(
                              color: HeracleTheme.textBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isMusclePage
                                ? 'Growth analytics'
                                : 'Nutritional intake analytics',
                            style: const TextStyle(
                              color: HeracleTheme.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      // Dynamic Selector Dropdown
                      _buildDynamicSelector(isMusclePage),
                    ],
                  ),
                  const Spacer(),
                  // Graph Area
                  Expanded(
                    flex: 12,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        _buildGraphView(isMusclePage: true),
                        _buildGraphView(isMusclePage: false),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? (isMusclePage
                                  ? const Color(0xFF7B61FF)
                                  : Colors.orange)
                              : Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicSelector(bool isMusclePage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          value: isMusclePage ? _selectedMuscle : _selectedDietMetric,
          dropdownColor: Colors.white,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: HeracleTheme.textGrey,
            size: 18,
          ),
          style: const TextStyle(
            color: HeracleTheme.textBlack,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                if (isMusclePage) {
                  _selectedMuscle = newValue;
                } else {
                  _selectedDietMetric = newValue;
                }
              });
            }
          },
          items: (isMusclePage ? _muscles : _dietMetrics)
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGraphView({required bool isMusclePage}) {
    // Mock data for the graph
    final dataPoints = isMusclePage
        ? [0.3, 0.45, 0.38, 0.6, 0.72, 0.65, 0.85]
        : [0.6, 0.75, 0.8, 0.7, 0.9, 0.85, 0.95];

    final color = isMusclePage ? const Color(0xFF7B61FF) : Colors.orange;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CustomPaint(
              size: Size.infinite,
              painter: _ProgressGraphPainter(
                data: dataPoints,
                color: color,
                isDarkTheme: false,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((day) => Text(
                    day,
                    style: const TextStyle(
                      color: HeracleTheme.textGrey,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ProgressGraphPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final bool isDarkTheme;

  _ProgressGraphPainter({
    required this.data,
    required this.color,
    this.isDarkTheme = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.2),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    final double segmentWidth = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      double x = i * segmentWidth;
      double y = size.height - (data[i] * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        double prevX = (i - 1) * segmentWidth;
        double prevY = size.height - (data[i - 1] * size.height);
        double controlX = (prevX + x) / 2;
        path.quadraticBezierTo(controlX, prevY, x, y);
        fillPath.quadraticBezierTo(controlX, prevY, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw grid lines
    final gridPaint = Paint()
      ..color = isDarkTheme 
          ? Colors.white.withOpacity(0.05) 
          : Colors.black.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 0; i < 4; i++) {
      double y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw data points
    final pointPaint = Paint()..color = color;
    final pointStrokePaint = Paint()
      ..color = isDarkTheme ? const Color(0xFF1A1F2C) : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < data.length; i++) {
      double x = i * segmentWidth;
      double y = size.height - (data[i] * size.height);

      canvas.drawCircle(Offset(x, y), 5, pointPaint);
      canvas.drawCircle(Offset(x, y), 5, pointStrokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressGraphPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.color != color || oldDelegate.isDarkTheme != isDarkTheme;
}
