import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/workout_preferences.dart';
import 'package:ai_heracle_fit/core/services/workout_preferences_service.dart';

class SetGoalScreen extends StatefulWidget {
  const SetGoalScreen({super.key});

  @override
  State<SetGoalScreen> createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _submitting = false;

  // ── State ──────────────────────────────────────────────────────────────────
  String _fitnessLevel = '';
  int _frequency = 3;
  String _workoutType = '';
  final TextEditingController _injuriesController = TextEditingController();
  final List<String> _availableDays = [];
  String _preferredTime = '';
  int _sessionDuration = 45;

  static const _totalPages = 7;

  final _days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];
  final _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void dispose() {
    _pageController.dispose();
    _injuriesController.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return _fitnessLevel.isNotEmpty;
      case 1:
        return true;
      case 2:
        return _workoutType.isNotEmpty;
      case 3:
        return true; // injuries optional
      case 4:
        return _availableDays.isNotEmpty;
      case 5:
        return _preferredTime.isNotEmpty;
      case 6:
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
    final prefs = WorkoutPreferences(
      fitnessLevel: _fitnessLevel,
      workoutFrequencyPerWeek: _frequency,
      preferredWorkoutType: _workoutType,
      injuries: _injuriesController.text.trim().isEmpty
          ? null
          : _injuriesController.text.trim(),
      availableDays: List.from(_availableDays),
      preferredWorkoutTime: _preferredTime,
      sessionDurationMins: _sessionDuration,
    );

    final success = await WorkoutPreferencesService.instance.savePreferences(
      prefs,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      Navigator.of(context).pop(true); // pop with true = refresh dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save preferences. Please try again.'),
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
                    _buildPage1FitnessLevel(),
                    _buildPage2Frequency(),
                    _buildPage3WorkoutType(),
                    _buildPage4Injuries(),
                    _buildPage5AvailableDays(),
                    _buildPage6PreferredTime(),
                    _buildPage7SessionDuration(),
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

  // ── Top bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          if (_currentPage > 0)
            GestureDetector(
              onTap: _back,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
            )
          else
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.close_rounded, size: 20),
              ),
            ),
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
  }

  Widget _buildProgressBar() {
    return Padding(
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
  }

  // ── Bottom bar ─────────────────────────────────────────────────────────────
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
                  isLast ? 'Finish Setup' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }

  // ── Page helpers ───────────────────────────────────────────────────────────
  Widget _pageShell({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Padding(
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
  }

  Widget _optionChip({
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
                color: Color(0xFFBAE014),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  // ── Page 1: Fitness Level ──────────────────────────────────────────────────
  Widget _buildPage1FitnessLevel() {
    return _pageShell(
      title: 'What\'s your\nfitness level?',
      subtitle: 'We\'ll personalise your plan based on this.',
      child: ListView(
        children: [
          _optionChip(
            label: 'Beginner',
            subtitle: 'New to working out or returning after a long break',
            value: 'beginner',
            selected: _fitnessLevel,
            icon: Icons.emoji_people_rounded,
            onTap: (v) => setState(() => _fitnessLevel = v),
          ),
          _optionChip(
            label: 'Intermediate',
            subtitle: 'Working out regularly for 6+ months',
            value: 'intermediate',
            selected: _fitnessLevel,
            icon: Icons.fitness_center_rounded,
            onTap: (v) => setState(() => _fitnessLevel = v),
          ),
          _optionChip(
            label: 'Advanced',
            subtitle: 'Training seriously for 2+ years',
            value: 'advanced',
            selected: _fitnessLevel,
            icon: Icons.bolt_rounded,
            onTap: (v) => setState(() => _fitnessLevel = v),
          ),
        ],
      ),
    );
  }

  // ── Page 2: Workout Frequency ──────────────────────────────────────────────
  Widget _buildPage2Frequency() {
    return _pageShell(
      title: 'How often do you\nwant to train?',
      subtitle: 'Per week — we\'ll schedule around your life.',
      child: Column(
        children: [
          const Spacer(),
          Text(
            '$_frequency',
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w900,
              color: HeracleTheme.textBlack,
              letterSpacing: -4,
            ),
          ),
          Text(
            'day${_frequency == 1 ? '' : 's'} per week',
            style: const TextStyle(
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
              value: _frequency.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              onChanged: (v) => setState(() => _frequency = v.round()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '1',
                  style: TextStyle(color: HeracleTheme.textGrey, fontSize: 12),
                ),
                Text(
                  '7',
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

  // ── Page 3: Workout Type ───────────────────────────────────────────────────
  Widget _buildPage3WorkoutType() {
    return _pageShell(
      title: 'What type of\nworkout do you prefer?',
      subtitle: 'Your AI coach will prioritise this style.',
      child: ListView(
        children: [
          _optionChip(
            label: 'Strength',
            subtitle: 'Weights, resistance training, muscle building',
            value: 'strength',
            selected: _workoutType,
            icon: Icons.fitness_center_rounded,
            onTap: (v) => setState(() => _workoutType = v),
          ),
          _optionChip(
            label: 'Cardio',
            subtitle: 'Running, cycling, HIIT, endurance',
            value: 'cardio',
            selected: _workoutType,
            icon: Icons.directions_run_rounded,
            onTap: (v) => setState(() => _workoutType = v),
          ),
          _optionChip(
            label: 'Flexibility',
            subtitle: 'Yoga, stretching, mobility work',
            value: 'flexibility',
            selected: _workoutType,
            icon: Icons.self_improvement_rounded,
            onTap: (v) => setState(() => _workoutType = v),
          ),
          _optionChip(
            label: 'Mixed',
            subtitle: 'A balanced combination of all types',
            value: 'mixed',
            selected: _workoutType,
            icon: Icons.shuffle_rounded,
            onTap: (v) => setState(() => _workoutType = v),
          ),
        ],
      ),
    );
  }

  // ── Page 4: Injuries ───────────────────────────────────────────────────────
  Widget _buildPage4Injuries() {
    return _pageShell(
      title: 'Any injuries or\nlimitations?',
      subtitle: 'Optional — your AI coach will work around them.',
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _injuriesController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'e.g. left knee pain, lower back issues…',
                hintStyle: TextStyle(color: HeracleTheme.textGrey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
              ),
              style: const TextStyle(
                fontSize: 15,
                color: HeracleTheme.textBlack,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: HeracleTheme.textGrey,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Leave blank if you have no limitations.',
                  style: TextStyle(fontSize: 12, color: HeracleTheme.textGrey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Page 5: Available Days ─────────────────────────────────────────────────
  Widget _buildPage5AvailableDays() {
    return _pageShell(
      title: 'Which days are\nyou available?',
      subtitle: 'Select all that apply.',
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemCount: _days.length,
        itemBuilder: (context, i) {
          final day = _days[i];
          final selected = _availableDays.contains(day);
          return GestureDetector(
            onTap: () => setState(() {
              selected ? _availableDays.remove(day) : _availableDays.add(day);
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF1D1B20) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF1D1B20)
                      : Colors.black.withOpacity(0.08),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(selected ? 0.12 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayLabels[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : HeracleTheme.textBlack,
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Color(0xFFBAE014),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Page 6: Preferred Time ─────────────────────────────────────────────────
  Widget _buildPage6PreferredTime() {
    return _pageShell(
      title: 'When do you\nprefer to workout?',
      subtitle: 'Your schedule, your rules.',
      child: ListView(
        children: [
          _optionChip(
            label: 'Morning',
            subtitle: 'Before 12pm — fresh start to the day',
            value: 'morning',
            selected: _preferredTime,
            icon: Icons.wb_sunny_rounded,
            onTap: (v) => setState(() => _preferredTime = v),
          ),
          _optionChip(
            label: 'Afternoon',
            subtitle: '12pm – 5pm — midday energy boost',
            value: 'afternoon',
            selected: _preferredTime,
            icon: Icons.wb_cloudy_rounded,
            onTap: (v) => setState(() => _preferredTime = v),
          ),
          _optionChip(
            label: 'Evening',
            subtitle: 'After 5pm — wind down and train',
            value: 'evening',
            selected: _preferredTime,
            icon: Icons.nights_stay_rounded,
            onTap: (v) => setState(() => _preferredTime = v),
          ),
        ],
      ),
    );
  }

  // ── Page 7: Session Duration ───────────────────────────────────────────────
  Widget _buildPage7SessionDuration() {
    final options = [15, 30, 45, 60, 90];
    return _pageShell(
      title: 'How long per\nsession?',
      subtitle: 'We\'ll pack the right amount of work in.',
      child: ListView(
        children: options
            .map(
              (mins) => _optionChip(
                label: '$mins minutes',
                subtitle: mins <= 20
                    ? 'Quick & intense'
                    : mins <= 45
                    ? 'Balanced session'
                    : 'Full training session',
                value: mins.toString(),
                selected: _sessionDuration.toString(),
                icon: Icons.timer_outlined,
                onTap: (_) => setState(() => _sessionDuration = mins),
              ),
            )
            .toList(),
      ),
    );
  }
}
