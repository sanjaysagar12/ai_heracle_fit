import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';

class AiCardsSection extends StatelessWidget {
  const AiCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
              ),
              const SizedBox(height: 16),
              _buildProfessionalSmallCard(
                title: 'Sleep Fixer',
                subtitle: 'Circadian Rhythm',
                icon: Icons.bedtime_rounded,
                iconBg: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFE65100),
              ),
            ],
          ),
        ),
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
                      height: 42, // Reduced from 46
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
  }) {
    return Container(
      height:
          142, // Reduced from 152 to match the new hero card height (142*2 + 16 = 300)
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.04), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 20),
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
    );
  }
}
