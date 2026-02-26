import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/diet_preferences.dart';
import 'package:ai_heracle_fit/core/services/diet_service.dart';

class DietPreferencesScreen extends StatefulWidget {
  const DietPreferencesScreen({super.key});

  @override
  State<DietPreferencesScreen> createState() => _DietPreferencesScreenState();
}

class _DietPreferencesScreenState extends State<DietPreferencesScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _submitting = false;

  String _dietaryPreference = '';
  double _dailyWater = 2.5;
  int _mealsPerDay = 3;

  static const _totalPages = 3;

  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return _dietaryPreference.isNotEmpty;
      case 1:
        return true;
      case 2:
        return true;
      default:
        return false;
    }
  }

  void _next() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _submit();
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);

    final prefs = DietPreferences(
      dietaryPreference: _dietaryPreference,
      dailyWaterLitres: double.parse(_dailyWater.toStringAsFixed(1)),
      mealsPerDay: _mealsPerDay,
    );

    final success = await DietService.instance.savePreferences(prefs);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      Navigator.of(context).pop(true); // signal success to caller
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save diet preferences. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [HeracleTheme.bgPink, Colors.white, HeracleTheme.bgBlue],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildProgressBar(),
              const SizedBox(height: 8),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  children: [
                    _buildPage1DietaryPreference(),
                    _buildPage2Water(),
                    _buildPage3Meals(),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Chrome ─────────────────────────────────────────────────────────────────
  Widget _buildTopBar() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
    child: Row(
      children: [
        if (_currentPage > 0)
          _iconBtn(Icons.arrow_back_rounded, _back)
        else
          _iconBtn(Icons.close_rounded, () => Navigator.of(context).pop()),
        const Spacer(),
        Text(
          '${_currentPage + 1} / $_totalPages',
          style: const TextStyle(
            color: HeracleTheme.textGrey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
        ],
      ),
      child: Icon(icon, size: 20),
    ),
  );

  Widget _buildProgressBar() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: (_currentPage + 1) / _totalPages,
        minHeight: 6,
        backgroundColor: Colors.black.withOpacity(0.08),
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
      ),
    ),
  );

  Widget _buildBottomBar() {
    final isLast = _currentPage == _totalPages - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _canProceed && !_submitting ? _next : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: _submitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  isLast ? 'Save Preferences' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }

  // ── Page shell ─────────────────────────────────────────────────────────────
  Widget _pageShell({
    required String title,
    required String subtitle,
    required Widget child,
  }) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: HeracleTheme.textBlack,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: HeracleTheme.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 28),
        Expanded(child: child),
      ],
    ),
  );

  Widget _chip({
    required String label,
    required String value,
    required String selected,
    required ValueChanged<String> onTap,
    String? subtitle,
    IconData? icon,
  }) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1B5E20)
                : Colors.black.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.12 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white70 : HeracleTheme.textGrey,
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : HeracleTheme.textBlack,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white60
                            : HeracleTheme.textGrey,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFA5D6A7),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  // ── Page 1: Dietary Preference ─────────────────────────────────────────────
  Widget _buildPage1DietaryPreference() => _pageShell(
    title: 'What\'s your\ndiet style?',
    subtitle: 'Your meal plan will be built around this.',
    child: ListView(
      children: [
        _chip(
          label: 'Omnivore',
          value: 'omnivore',
          selected: _dietaryPreference,
          subtitle: 'Eats everything — balanced diet',
          icon: Icons.restaurant_rounded,
          onTap: (v) => setState(() => _dietaryPreference = v),
        ),
        _chip(
          label: 'Vegetarian',
          value: 'vegetarian',
          selected: _dietaryPreference,
          subtitle: 'No meat, includes dairy & eggs',
          icon: Icons.eco_rounded,
          onTap: (v) => setState(() => _dietaryPreference = v),
        ),
        _chip(
          label: 'Vegan',
          value: 'vegan',
          selected: _dietaryPreference,
          subtitle: 'No animal products at all',
          icon: Icons.local_florist_rounded,
          onTap: (v) => setState(() => _dietaryPreference = v),
        ),
        _chip(
          label: 'Keto',
          value: 'keto',
          selected: _dietaryPreference,
          subtitle: 'High fat, very low carb',
          icon: Icons.bolt_rounded,
          onTap: (v) => setState(() => _dietaryPreference = v),
        ),
        _chip(
          label: 'Paleo',
          value: 'paleo',
          selected: _dietaryPreference,
          subtitle: 'Whole foods, no processed grains',
          icon: Icons.grass_rounded,
          onTap: (v) => setState(() => _dietaryPreference = v),
        ),
        _chip(
          label: 'Gluten Free',
          value: 'gluten_free',
          selected: _dietaryPreference,
          subtitle: 'No gluten-containing foods',
          icon: Icons.no_food_rounded,
          onTap: (v) => setState(() => _dietaryPreference = v),
        ),
      ],
    ),
  );

  // ── Page 2: Daily Water ────────────────────────────────────────────────────
  Widget _buildPage2Water() => _pageShell(
    title: 'Daily water\ngoal?',
    subtitle: 'Staying hydrated is key to performance.',
    child: Column(
      children: [
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _dailyWater.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                color: HeracleTheme.textBlack,
                letterSpacing: -4,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                '  L',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: HeracleTheme.textGrey,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Quick select pills
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1.5, 2.0, 2.5, 3.0, 3.5]
              .map(
                (v) => GestureDetector(
                  onTap: () => setState(() => _dailyWater = v),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _dailyWater == v
                          ? const Color(0xFF2E7D32)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _dailyWater == v
                            ? const Color(0xFF2E7D32)
                            : Colors.black12,
                      ),
                    ),
                    child: Text(
                      '${v}L',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _dailyWater == v
                            ? Colors.white
                            : HeracleTheme.textGrey,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF2E7D32),
            inactiveTrackColor: Colors.black12,
            thumbColor: const Color(0xFF2E7D32),
            overlayColor: const Color(0xFF2E7D32).withOpacity(0.1),
            trackHeight: 6,
          ),
          child: Slider(
            value: _dailyWater,
            min: 1.0,
            max: 5.0,
            divisions: 16,
            onChanged: (v) => setState(() => _dailyWater = (v * 2).round() / 2),
          ),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );

  // ── Page 3: Meals per Day ──────────────────────────────────────────────────
  Widget _buildPage3Meals() => _pageShell(
    title: 'How many meals\nper day?',
    subtitle: 'We\'ll space your nutrition plan around this.',
    child: Column(
      children: [
        const Spacer(),
        Text(
          '$_mealsPerDay',
          style: const TextStyle(
            fontSize: 90,
            fontWeight: FontWeight.w900,
            color: HeracleTheme.textBlack,
            letterSpacing: -4,
          ),
        ),
        Text(
          'meal${_mealsPerDay == 1 ? '' : 's'} per day',
          style: const TextStyle(
            fontSize: 16,
            color: HeracleTheme.textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [2, 3, 4, 5, 6]
              .map(
                (n) => GestureDetector(
                  onTap: () => setState(() => _mealsPerDay = n),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _mealsPerDay == n
                          ? const Color(0xFF2E7D32)
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _mealsPerDay == n
                            ? const Color(0xFF2E7D32)
                            : Colors.black12,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            _mealsPerDay == n ? 0.12 : 0.04,
                          ),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$n',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _mealsPerDay == n
                              ? Colors.white
                              : HeracleTheme.textBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );
}
