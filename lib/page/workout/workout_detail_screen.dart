import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/workout_card_data.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutCardData todayCard;
  final List<WorkoutSession> sessions;

  const WorkoutDetailScreen({
    super.key,
    required this.todayCard,
    required this.sessions,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  String _selectedCategory = 'All';

  List<String> get _categories {
    final cats = widget.sessions.map((s) => s.category).toSet().toList();
    return ['All', ...cats];
  }

  List<WorkoutSession> get _filtered => _selectedCategory == 'All'
      ? widget.sessions
      : widget.sessions.where((s) => s.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Background gradient (matches SleepCoach / Diet screens) ──────
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
                        // ── Muscle Progress graph ─────────────────────────
                        const _MuscleProgressCard(),
                        const SizedBox(height: 24),
                        // ── Action buttons ────────────────────────────────
                        _buildActionButtons(),
                        const SizedBox(height: 28),
                        // ── Your Sessions ─────────────────────────────────
                        const Text(
                          'Your Sessions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: HeracleTheme.textBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'All your created and AI-suggested sessions.',
                          style: TextStyle(
                            fontSize: 14,
                            color: HeracleTheme.textGrey.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_categories.length > 2) _buildCategoryChips(),
                        if (_categories.length > 2) const SizedBox(height: 16),
                        ...widget.todayCard.sessions.map(
                          (s) => _buildSessionCard(s, isAi: true),
                        ),
                        if (_filtered.isEmpty &&
                            widget.todayCard.sessions.isEmpty)
                          _buildEmpty()
                        else
                          ..._filtered.map((s) => _buildSessionCard(s)),
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

  // ── Header (matches SleepCoach / Diet style) ───────────────────────────────
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
            "Today's Workout",
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

  // ── Action buttons ─────────────────────────────────────────────────────────
  Widget _buildActionButtons() => Column(
    children: [
      SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, size: 20, color: Colors.white),
          label: const Text(
            'Start Empty Session',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: HeracleTheme.textBlack,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: HeracleTheme.textBlack,
            side: const BorderSide(color: HeracleTheme.textBlack, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Create Workout Session',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ],
  );

  // ── Category filter chips ──────────────────────────────────────────────────
  Widget _buildCategoryChips() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? HeracleTheme.textBlack : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? HeracleTheme.textBlack
                    : Colors.black.withOpacity(0.08),
              ),
            ),
            child: Text(
              cat,
              style: TextStyle(
                color: isSelected ? Colors.white : HeracleTheme.textGrey,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );

  // ── Session card ───────────────────────────────────────────────────────────
  Widget _buildSessionCard(WorkoutSession session, {bool isAi = false}) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      session.title,
                      style: const TextStyle(
                        color: HeracleTheme.textBlack,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (isAi) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: HeracleTheme.givingliYellowDark.withOpacity(
                          0.12,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: HeracleTheme.givingliYellowDark.withOpacity(
                            0.25,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 10,
                            color: HeracleTheme.givingliYellowDark,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'AI',
                            style: TextStyle(
                              color: HeracleTheme.givingliYellowDark,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  PopupMenuButton<String>(
                    onSelected: (_) {},
                    color: Colors.white,
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: HeracleTheme.textGrey,
                    ),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          'Edit',
                          style: TextStyle(color: HeracleTheme.textBlack),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ── Description ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                session.content,
                style: TextStyle(
                  color: HeracleTheme.textGrey.withOpacity(0.85),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // ── Avatars + count ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildExerciseAvatars(session.exercises),
                  const SizedBox(width: 10),
                  Text(
                    '${session.exercisesCount}+ exercises',
                    style: TextStyle(
                      color: HeracleTheme.textGrey.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // ── Start Session button ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HeracleTheme.textBlack,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Start Session',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseAvatars(List<WorkoutExercise> exercises) {
    const maxVisible = 3;
    final visible = exercises.take(maxVisible).toList();
    return SizedBox(
      width: maxVisible * 28.0 + 4,
      height: 34,
      child: Stack(
        children: visible.asMap().entries.map((e) {
          final i = e.key;
          final ex = e.value;
          return Positioned(
            left: i * 22.0,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: ex.image != null && ex.image!.isNotEmpty
                    ? Image.network(
                        ex.image!,
                        width: 34,
                        height: 34,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                      )
                    : _avatarPlaceholder(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _avatarPlaceholder() => ColoredBox(
    color: Colors.grey.shade100,
    child: Icon(
      Icons.fitness_center_rounded,
      size: 16,
      color: HeracleTheme.textGrey,
    ),
  );

  Widget _buildEmpty() => Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.black.withOpacity(0.04)),
    ),
    child: Column(
      children: [
        Icon(
          Icons.fitness_center_rounded,
          size: 40,
          color: HeracleTheme.textGrey.withOpacity(0.4),
        ),
        const SizedBox(height: 12),
        const Text(
          'No sessions yet',
          style: TextStyle(
            color: HeracleTheme.textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tap "Create Workout Session" to get started.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: HeracleTheme.textGrey.withOpacity(0.7),
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

// ── Muscle Progress Card ─────────────────────────────────────────────────────

class _MuscleProgressCard extends StatefulWidget {
  const _MuscleProgressCard();

  @override
  State<_MuscleProgressCard> createState() => _MuscleProgressCardState();
}

class _MuscleProgressCardState extends State<_MuscleProgressCard> {
  String _selectedMuscle = 'Chest';

  final List<String> _muscles = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
  ];

  final Map<String, List<double>> _muscleData = {
    'Chest': [0.30, 0.45, 0.38, 0.60, 0.72, 0.65, 0.85],
    'Back': [0.50, 0.60, 0.55, 0.70, 0.68, 0.75, 0.80],
    'Legs': [0.20, 0.35, 0.50, 0.45, 0.65, 0.78, 0.70],
    'Shoulders': [0.40, 0.48, 0.55, 0.60, 0.58, 0.72, 0.80],
    'Arms': [0.35, 0.50, 0.60, 0.55, 0.70, 0.68, 0.90],
    'Core': [0.60, 0.70, 0.65, 0.80, 0.75, 0.85, 0.95],
  };

  @override
  Widget build(BuildContext context) {
    final data = _muscleData[_selectedMuscle] ?? _muscleData['Chest']!;

    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Muscle Progress',
                      style: TextStyle(
                        color: HeracleTheme.textBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Weekly growth analytics',
                      style: TextStyle(
                        color: HeracleTheme.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.04)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    value: _selectedMuscle,
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
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedMuscle = v);
                    },
                    items: _muscles
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Graph ──────────────────────────────────────────────────────
          SizedBox(
            height: 130,
            child: CustomPaint(
              size: Size.infinite,
              painter: _WorkoutGraphPainter(
                data: data,
                color: HeracleTheme.textBlack,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ── Day labels ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (d) => Text(
                    d,
                    style: TextStyle(
                      color: HeracleTheme.textGrey.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Graph Painter ────────────────────────────────────────────────────────────

class _WorkoutGraphPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  const _WorkoutGraphPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.10), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final gridPaint = Paint()
      ..color = Colors.black.withOpacity(0.04)
      ..strokeWidth = 1;

    for (int i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    final fill = Path();
    final sw = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * sw;
      final y = size.height - data[i] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fill.moveTo(x, size.height);
        fill.lineTo(x, y);
      } else {
        final px = (i - 1) * sw;
        final py = size.height - data[i - 1] * size.height;
        final cx = (px + x) / 2;
        path.quadraticBezierTo(cx, py, x, y);
        fill.quadraticBezierTo(cx, py, x, y);
      }
    }
    fill.lineTo(size.width, size.height);
    fill.close();

    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(path, linePaint);

    final dot = Paint()..color = color;
    final ring = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < data.length; i++) {
      final x = i * sw;
      final y = size.height - data[i] * size.height;
      canvas.drawCircle(Offset(x, y), 4.5, dot);
      canvas.drawCircle(Offset(x, y), 4.5, ring);
    }
  }

  @override
  bool shouldRepaint(_WorkoutGraphPainter old) =>
      old.data != data || old.color != color;
}
