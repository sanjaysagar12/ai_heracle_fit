import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/body_metrics.dart';
import 'package:ai_heracle_fit/core/services/body_metrics_service.dart';
import 'package:ai_heracle_fit/page/dashboard/presentation/dashboard_screen.dart';

class BodyMetricsScreen extends StatefulWidget {
  const BodyMetricsScreen({super.key});

  @override
  State<BodyMetricsScreen> createState() => _BodyMetricsScreenState();
}

class _BodyMetricsScreenState extends State<BodyMetricsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _submitting = false;

  // ── State ──────────────────────────────────────────────────────────────────
  int _age = 25;
  String _gender = '';
  double _heightCm = 170;
  bool _useMetricHeight = true;
  double _weightKg = 70;
  bool _useMetricWeight = true;
  String _bodyType = '';
  String _goal = '';

  static const _totalPages = 6;

  // ── Validation ─────────────────────────────────────────────────────────────
  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return _gender.isNotEmpty;
      case 1:
        return true; // age slider always valid
      case 2:
        return true; // height always valid
      case 3:
        return true; // weight always valid
      case 4:
        return _bodyType.isNotEmpty;
      case 5:
        return _goal.isNotEmpty;
      default:
        return false;
    }
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
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

    final heightFt = BodyMetrics.cmToFt(_heightCm);
    final weightLbs = BodyMetrics.kgToLbs(_weightKg);

    final metrics = BodyMetrics(
      age: _age,
      gender: _gender,
      heightCm: double.parse(_heightCm.toStringAsFixed(1)),
      heightFt: heightFt,
      weightKg: double.parse(_weightKg.toStringAsFixed(1)),
      weightLbs: weightLbs,
      bodyType: _bodyType,
      goal: _goal,
    );

    final success = await BodyMetricsService.instance.saveMetrics(metrics);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      // Go to dashboard, clearing the entire back stack
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DashboardScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
        (_) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save your details. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
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
                    _buildPage1Gender(),
                    _buildPage2Age(),
                    _buildPage3Height(),
                    _buildPage4Weight(),
                    _buildPage5BodyType(),
                    _buildPage6Goal(),
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

  // ── Shared chrome ──────────────────────────────────────────────────────────
  Widget _buildTopBar() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
    child: Row(
      children: [
        if (_currentPage > 0)
          _iconButton(Icons.arrow_back_rounded, _back)
        else
          const SizedBox(width: 40),
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

  Widget _iconButton(IconData icon, VoidCallback onTap) => GestureDetector(
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
        valueColor: const AlwaysStoppedAnimation<Color>(
          HeracleTheme.primaryPurple,
        ),
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
            backgroundColor: const Color(0xFF1D1B20),
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
                  isLast ? 'Let\'s Go 🚀' : 'Continue',
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

  // ── Option chip ────────────────────────────────────────────────────────────
  Widget _chip({
    required String label,
    required String value,
    required String selected,
    required ValueChanged<String> onTap,
    String? subtitle,
    IconData? icon,
    Widget? leading,
  }) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D1B20) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1D1B20)
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
            if (leading != null) ...[
              leading,
              const SizedBox(width: 14),
            ] else if (icon != null) ...[
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
                color: Color(0xFFBAE014),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  // ── Page 1: Gender ─────────────────────────────────────────────────────────
  Widget _buildPage1Gender() => _pageShell(
    title: 'What\'s your\ngender?',
    subtitle: 'Used to personalise your fitness plan.',
    child: ListView(
      children: [
        _chip(
          label: 'Male',
          value: 'male',
          selected: _gender,
          leading: const Text('♂️', style: TextStyle(fontSize: 22)),
          onTap: (v) => setState(() => _gender = v),
        ),
        _chip(
          label: 'Female',
          value: 'female',
          selected: _gender,
          leading: const Text('♀️', style: TextStyle(fontSize: 22)),
          onTap: (v) => setState(() => _gender = v),
        ),
        _chip(
          label: 'Other / Prefer not to say',
          value: 'other',
          selected: _gender,
          icon: Icons.person_rounded,
          onTap: (v) => setState(() => _gender = v),
        ),
      ],
    ),
  );

  // ── Page 2: Age ────────────────────────────────────────────────────────────
  Widget _buildPage2Age() => _pageShell(
    title: 'How old\nare you?',
    subtitle: 'We calibrate intensity and recovery based on age.',
    child: Column(
      children: [
        const Spacer(),
        Text(
          '$_age',
          style: const TextStyle(
            fontSize: 90,
            fontWeight: FontWeight.w900,
            color: HeracleTheme.textBlack,
            letterSpacing: -4,
          ),
        ),
        const Text(
          'years old',
          style: TextStyle(
            fontSize: 16,
            color: HeracleTheme.textGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 32),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF1D1B20),
            inactiveTrackColor: Colors.black12,
            thumbColor: const Color(0xFF1D1B20),
            overlayColor: const Color(0xFF1D1B20).withOpacity(0.1),
            trackHeight: 6,
          ),
          child: Slider(
            value: _age.toDouble(),
            min: 13,
            max: 80,
            divisions: 67,
            onChanged: (v) => setState(() => _age = v.round()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '13',
                style: TextStyle(color: HeracleTheme.textGrey, fontSize: 12),
              ),
              Text(
                '80',
                style: TextStyle(color: HeracleTheme.textGrey, fontSize: 12),
              ),
            ],
          ),
        ),
        const Spacer(flex: 2),
      ],
    ),
  );

  // ── Page 3: Height ─────────────────────────────────────────────────────────
  Widget _buildPage3Height() {
    final heightFt = BodyMetrics.cmToFt(_heightCm);
    return _pageShell(
      title: 'What\'s your\nheight?',
      subtitle: 'Switch between cm and ft.',
      child: Column(
        children: [
          // Unit toggle
          _unitToggle(
            leftLabel: 'cm',
            rightLabel: 'ft',
            useLeft: _useMetricHeight,
            onToggle: (v) => setState(() => _useMetricHeight = v),
          ),
          const Spacer(),
          Text(
            _useMetricHeight
                ? '${_heightCm.toStringAsFixed(0)} cm'
                : '$heightFt ft',
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w900,
              color: HeracleTheme.textBlack,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 32),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF1D1B20),
              inactiveTrackColor: Colors.black12,
              thumbColor: const Color(0xFF1D1B20),
              overlayColor: const Color(0xFF1D1B20).withOpacity(0.1),
              trackHeight: 6,
            ),
            child: Slider(
              value: _heightCm,
              min: 120,
              max: 220,
              divisions: 100,
              onChanged: (v) => setState(() => _heightCm = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '120 cm',
                  style: TextStyle(color: HeracleTheme.textGrey, fontSize: 12),
                ),
                Text(
                  '220 cm',
                  style: TextStyle(color: HeracleTheme.textGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  // ── Page 4: Weight ─────────────────────────────────────────────────────────
  Widget _buildPage4Weight() {
    final weightLbs = BodyMetrics.kgToLbs(_weightKg);
    return _pageShell(
      title: 'What\'s your\nweight?',
      subtitle: 'Switch between kg and lbs.',
      child: Column(
        children: [
          _unitToggle(
            leftLabel: 'kg',
            rightLabel: 'lbs',
            useLeft: _useMetricWeight,
            onToggle: (v) => setState(() => _useMetricWeight = v),
          ),
          const Spacer(),
          Text(
            _useMetricWeight
                ? '${_weightKg.toStringAsFixed(0)} kg'
                : '${weightLbs.toStringAsFixed(0)} lbs',
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w900,
              color: HeracleTheme.textBlack,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 32),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF1D1B20),
              inactiveTrackColor: Colors.black12,
              thumbColor: const Color(0xFF1D1B20),
              overlayColor: const Color(0xFF1D1B20).withOpacity(0.1),
              trackHeight: 6,
            ),
            child: Slider(
              value: _weightKg,
              min: 30,
              max: 200,
              divisions: 170,
              onChanged: (v) => setState(() => _weightKg = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '30 kg',
                  style: TextStyle(color: HeracleTheme.textGrey, fontSize: 12),
                ),
                Text(
                  '200 kg',
                  style: TextStyle(color: HeracleTheme.textGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  // ── Page 5: Body Type ──────────────────────────────────────────────────────
  Widget _buildPage5BodyType() => _pageShell(
    title: 'What\'s your\nbody type?',
    subtitle: 'This helps calibrate your nutrition and training split.',
    child: ListView(
      children: [
        _chip(
          label: 'Ectomorph',
          value: 'ectomorph',
          selected: _bodyType,
          subtitle: 'Lean & long — struggles to gain weight',
          icon: Icons.height_rounded,
          onTap: (v) => setState(() => _bodyType = v),
        ),
        _chip(
          label: 'Mesomorph',
          value: 'mesomorph',
          selected: _bodyType,
          subtitle: 'Athletic — gains muscle and loses fat easily',
          icon: Icons.fitness_center_rounded,
          onTap: (v) => setState(() => _bodyType = v),
        ),
        _chip(
          label: 'Endomorph',
          value: 'endomorph',
          selected: _bodyType,
          subtitle: 'Solid & stocky — tends to store fat easily',
          icon: Icons.circle_outlined,
          onTap: (v) => setState(() => _bodyType = v),
        ),
      ],
    ),
  );

  // ── Page 6: Goal ───────────────────────────────────────────────────────────
  Widget _buildPage6Goal() => _pageShell(
    title: 'What\'s your\nprimary goal?',
    subtitle: 'Your entire plan will be built around this.',
    child: ListView(
      children: [
        _chip(
          label: 'Muscle Gain',
          value: 'muscle_gain',
          selected: _goal,
          subtitle: 'Build strength and size',
          icon: Icons.fitness_center_rounded,
          onTap: (v) => setState(() => _goal = v),
        ),
        _chip(
          label: 'Fat Loss',
          value: 'fat_loss',
          selected: _goal,
          subtitle: 'Burn fat while preserving muscle',
          icon: Icons.local_fire_department_rounded,
          onTap: (v) => setState(() => _goal = v),
        ),
        _chip(
          label: 'Endurance',
          value: 'endurance',
          selected: _goal,
          subtitle: 'Improve stamina and cardiovascular fitness',
          icon: Icons.directions_run_rounded,
          onTap: (v) => setState(() => _goal = v),
        ),
        _chip(
          label: 'Flexibility',
          value: 'flexibility',
          selected: _goal,
          subtitle: 'Increase mobility and reduce injury risk',
          icon: Icons.self_improvement_rounded,
          onTap: (v) => setState(() => _goal = v),
        ),
        _chip(
          label: 'General Fitness',
          value: 'general_fitness',
          selected: _goal,
          subtitle: 'Stay healthy and active overall',
          icon: Icons.favorite_rounded,
          onTap: (v) => setState(() => _goal = v),
        ),
      ],
    ),
  );

  // ── Unit toggle helper ─────────────────────────────────────────────────────
  Widget _unitToggle({
    required String leftLabel,
    required String rightLabel,
    required bool useLeft,
    required ValueChanged<bool> onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _toggleSegment(leftLabel, useLeft, () => onToggle(true)),
          _toggleSegment(rightLabel, !useLeft, () => onToggle(false)),
        ],
      ),
    );
  }

  Widget _toggleSegment(String label, bool active, VoidCallback onTap) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: active ? HeracleTheme.textBlack : HeracleTheme.textGrey,
              ),
            ),
          ),
        ),
      );
}
