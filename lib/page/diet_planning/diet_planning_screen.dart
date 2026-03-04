import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/page/diet_planning/diet_plan_model.dart';
import 'dart:ui';
import 'dart:math';

class TrackedFood {
  String name;
  int calories;
  int protein;
  int carbs;
  int fats;
  int fiber;

  TrackedFood({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
  });
}

class DietPlanningScreen extends StatefulWidget {
  const DietPlanningScreen({super.key});

  @override
  State<DietPlanningScreen> createState() => _DietPlanningScreenState();
}

class _DietPlanningScreenState extends State<DietPlanningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _aiFoodController = TextEditingController();

  final List<TrackedFood> _scannedPreviewMeals = [];

  final List<TrackedFood> _trackedMeals = [
    TrackedFood(
      name: 'Oatmeal & Berries',
      calories: 320,
      protein: 12,
      carbs: 54,
      fats: 8,
      fiber: 6,
    ),
    TrackedFood(
      name: 'Chicken Salad',
      calories: 450,
      protein: 42,
      carbs: 15,
      fats: 15,
      fiber: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _aiFoodController.dispose();
    super.dispose();
  }

  Widget _buildAiInputBox() {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 8),
      padding: const EdgeInsets.only(left: 20, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: HeracleTheme.textBlack.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _aiFoodController,
              decoration: const InputDecoration(
                hintText: 'e.g. "Oatmeal with berries"',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
                hintStyle: TextStyle(
                  color: HeracleTheme.textGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              style: const TextStyle(
                color: HeracleTheme.textBlack,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: HeracleTheme.givingliGreenDark,
            ),
            child: IconButton(
              onPressed: () {
                if (_aiFoodController.text.trim().isNotEmpty) {
                  setState(() {
                    _scannedPreviewMeals.insert(
                      0,
                      TrackedFood(
                        name: _aiFoodController.text.trim(),
                        calories: 250 + Random().nextInt(300),
                        protein: 8 + Random().nextInt(25),
                        carbs: 20 + Random().nextInt(40),
                        fats: 5 + Random().nextInt(15),
                        fiber: 2 + Random().nextInt(8),
                      ),
                    );
                    _aiFoodController.clear();
                  });
                }
              },
              icon: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewMealsQueue() {
    if (_scannedPreviewMeals.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scanned Meals Queue',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: HeracleTheme.givingliGreenDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          ..._scannedPreviewMeals.asMap().entries.map((entry) {
            final int index = entry.key;
            final TrackedFood previewMeal = entry.value;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: HeracleTheme.givingliGreenDark.withOpacity(0.15),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: HeracleTheme.givingliGreenDark.withOpacity(0.03),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: previewMeal.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: HeracleTheme.textBlack,
                            letterSpacing: -0.5,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setState(() {
                              previewMeal.name = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Calories in the same row
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: HeracleTheme.textBlack.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 35,
                              child: TextFormField(
                                initialValue: previewMeal.calories.toString(),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: HeracleTheme.textBlack,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  int? parsed = int.tryParse(val);
                                  if (parsed != null) {
                                    setState(
                                      () => previewMeal.calories = parsed,
                                    );
                                  }
                                },
                              ),
                            ),
                            const Text(
                              'kcal',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: HeracleTheme.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _scannedPreviewMeals.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.redAccent,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildEditableMacroStat(
                        'Carbs (g)',
                        previewMeal.carbs,
                        (val) => setState(() => previewMeal.carbs = val),
                      ),
                      _buildEditableMacroStat(
                        'Protein (g)',
                        previewMeal.protein,
                        (val) => setState(() => previewMeal.protein = val),
                      ),
                      _buildEditableMacroStat(
                        'Fats (g)',
                        previewMeal.fats,
                        (val) => setState(() => previewMeal.fats = val),
                      ),
                      _buildEditableMacroStat(
                        'Fiber (g)',
                        previewMeal.fiber,
                        (val) => setState(() => previewMeal.fiber = val),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _trackedMeals.insertAll(0, _scannedPreviewMeals);
                  _scannedPreviewMeals.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HeracleTheme.textBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Add ${_scannedPreviewMeals.length} Meal${_scannedPreviewMeals.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackedMealsList() {
    if (_trackedMeals.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Logged Meals',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: HeracleTheme.textBlack,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          ..._trackedMeals.asMap().entries.map((entry) {
            int index = entry.key;
            TrackedFood meal = entry.value;
            return _buildEditableMealCard(meal, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEditableMealCard(TrackedFood meal, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.012),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: meal.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: HeracleTheme.textBlack,
                    letterSpacing: -0.5,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    setState(() {
                      meal.name = val;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Calories in the same row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: HeracleTheme.textBlack.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 35,
                      child: TextFormField(
                        initialValue: meal.calories.toString(),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: HeracleTheme.textBlack,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          int? parsed = int.tryParse(val);
                          if (parsed != null) {
                            setState(() => meal.calories = parsed);
                          }
                        },
                      ),
                    ),
                    const Text(
                      'kcal',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: HeracleTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _trackedMeals.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEditableMacroStat(
                'Carbs (g)',
                meal.carbs,
                (val) => setState(() => meal.carbs = val),
              ),
              _buildEditableMacroStat(
                'Protein (g)',
                meal.protein,
                (val) => setState(() => meal.protein = val),
              ),
              _buildEditableMacroStat(
                'Fats (g)',
                meal.fats,
                (val) => setState(() => meal.fats = val),
              ),
              _buildEditableMacroStat(
                'Fiber (g)',
                meal.fiber,
                (val) => setState(() => meal.fiber = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditableMacroStat(
    String label,
    int value,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: HeracleTheme.textGrey.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: 55,
          child: TextFormField(
            initialValue: value.toString(),
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: HeracleTheme.textBlack,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            onChanged: (val) {
              int? parsed = int.tryParse(val);
              if (parsed != null) {
                onChanged(parsed);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: null,
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
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // TAB 1: Diet Plan
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAiSummaryCard(),
                            const SizedBox(height: 33),
                            const Text(
                              'Suggested for You',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: HeracleTheme.textBlack,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Based on your previous diet history and muscle recovery needs.',
                              style: TextStyle(
                                fontSize: 14,
                                color: HeracleTheme.textGrey.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ...mockDietPlans.map(
                              (plan) => _buildDietPlanCard(plan),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),

                      // TAB 2: Track Calories (Matched to Screenshot UI)
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "Today" / "Yesterday" header
                            Row(
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Today',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: HeracleTheme.textBlack,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: HeracleTheme.textBlack,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    'Yesterday',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: HeracleTheme.textBlack.withOpacity(
                                        0.5,
                                      ),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildDailyMacroSummary(),
                            _buildPreviewMealsQueue(),
                            _buildAiInputBox(),
                            _buildTrackedMealsList(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: HeracleTheme.textBlack.withOpacity(0.04),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TabBar(
          controller: _tabController,
          onTap: (_) => setState(() {}), // Update FAB visibility
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: HeracleTheme.textBlack,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          labelColor: Colors.white,
          unselectedLabelColor: HeracleTheme.textGrey,
          labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Plan'),
            Tab(text: 'Track'),
          ],
        ),
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
            'Diet & Nutrition',
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
              color: HeracleTheme.givingliGreen.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: HeracleTheme.givingliGreenDark,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab 1 Widgets ──────────────────────────────────────────────────────────

  Widget _buildAiSummaryCard() {
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
              Icons.auto_awesome_rounded,
              size: 120,
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
                        color: HeracleTheme.givingliGreenDark.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: HeracleTheme.givingliGreenDark.withOpacity(
                            0.3,
                          ),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 14,
                            color: HeracleTheme.givingliGreenDark,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'AI INSIGHT',
                            style: TextStyle(
                              color: HeracleTheme.givingliGreenDark,
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
                  'Based on your tracked meals, to reach your daily goal you still need to consume:',
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
                    _buildNutrientStat('650', 'kcal', 'Calories'),
                    const SizedBox(width: 40),
                    _buildNutrientStat('48', 'g', 'Protein'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientStat(String value, String unit, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
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
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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

  Widget _buildDietPlanCard(DietPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: plan.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(plan.icon, color: plan.color, size: 24),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      color: HeracleTheme.textGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  plan.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: HeracleTheme.textBlack,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plan.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: HeracleTheme.textGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildMiniMacroStat('${plan.calories}kcal'),
                    const SizedBox(width: 8),
                    _buildMiniMacroStat('${plan.protein}g Protein'),
                    const SizedBox(width: 8),
                    _buildMiniMacroStat('${plan.carbs}g Carbs'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniMacroStat(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: HeracleTheme.textBlack.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: HeracleTheme.textBlack,
        ),
      ),
    );
  }

  // ── Tab 2 Widgets (Screenshot implementation) ───────────────────────────────

  Widget _buildDailyMacroSummary() {
    int totalCals = _trackedMeals.fold(0, (sum, m) => sum + m.calories);
    int totalProtein = _trackedMeals.fold(0, (sum, m) => sum + m.protein);
    int totalCarbs = _trackedMeals.fold(0, (sum, m) => sum + m.carbs);
    int totalFats = _trackedMeals.fold(0, (sum, m) => sum + m.fats);
    int totalFiber = _trackedMeals.fold(0, (sum, m) => sum + m.fiber);

    // Mock goals
    int goalCals = 2400;
    int goalProtein = 180;
    int goalCarbs = 250;
    int goalFats = 70;
    int goalFiber = 30;

    int calsDiff = goalCals - totalCals;
    int proteinDiff = totalProtein - goalProtein;
    int carbsDiff = goalCarbs - totalCarbs;
    int fatsDiff = goalFats - totalFats;
    int fiberDiff = goalFiber - totalFiber;

    // Determine if over or left
    String calsStatus = calsDiff >= 0 ? "Calories left" : "Calories over";
    String proteinStatus = proteinDiff > 0 ? "Protein over" : "Protein left";
    String carbsStatus = carbsDiff > 0 ? "Carbs over" : "Carbs left";
    String fatsStatus = fatsDiff > 0 ? "Fats over" : "Fats left";
    String fiberStatus = fiberDiff > 0 ? "Fiber over" : "Fiber left";

    double calsProgress = (totalCals / goalCals).clamp(0.0, 1.0);
    double proteinProgress = (totalProtein / goalProtein).clamp(0.0, 1.0);
    double carbsProgress = (totalCarbs / goalCarbs).clamp(0.0, 1.0);
    double fatsProgress = (totalFats / goalFats).clamp(0.0, 1.0);
    double fiberProgress = (totalFiber / goalFiber).clamp(0.0, 1.0);

    return Column(
      children: [
        // ── Main unified calorie card ───────────────────────────────────────────
        Container(
          width: double.infinity,
          height: 95,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.015),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${calsDiff.abs()}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: HeracleTheme.textBlack,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    calsStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: HeracleTheme.textBlack.withOpacity(0.5),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: CustomPaint(
                    painter: _MacroRingPainter(
                      progress: calsProgress,
                      activeColor: HeracleTheme.textBlack,
                      bgColor: HeracleTheme.textBlack.withOpacity(0.06),
                      strokeWidth: 6,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: HeracleTheme.textBlack.withOpacity(0.8),
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ── Macro cards in a single row ──────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: _buildSmallMacroCard(
                value: '${proteinDiff.abs()}g',
                status: proteinStatus,
                progress: proteinProgress,
                activeColor: const Color(0xFFE55A6B),
                bgColor: const Color(0xFFE55A6B).withOpacity(0.12),
                icon: Icons.fastfood_rounded,
                isOver: proteinDiff > 0,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallMacroCard(
                value: '${carbsDiff.abs()}g',
                status: carbsStatus,
                progress: carbsProgress,
                activeColor: const Color(0xFFF39C12),
                bgColor: const Color(0xFFF39C12).withOpacity(0.12),
                icon: Icons.grain_rounded,
                isOver: carbsDiff > 0,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallMacroCard(
                value: '${fatsDiff.abs()}g',
                status: fatsStatus,
                progress: fatsProgress,
                activeColor: const Color(0xFF4A90E2),
                bgColor: const Color(0xFF4A90E2).withOpacity(0.12),
                icon: Icons.water_drop_rounded,
                isOver: fatsDiff > 0,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallMacroCard(
                value: '${fiberDiff.abs()}g',
                status: fiberStatus,
                progress: fiberProgress,
                activeColor: HeracleTheme.givingliGreenDark,
                bgColor: HeracleTheme.givingliGreenDark.withOpacity(0.12),
                icon: Icons.eco_rounded,
                isOver: fiberDiff > 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallMacroCard({
    required String value,
    required String status,
    required double progress,
    required Color activeColor,
    required Color bgColor,
    required IconData icon,
    bool isOver = false,
  }) {
    return Container(
      height: 85, // Reduced from 100
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14), // Reduced from 16
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 12, // Reduced from 14
              fontWeight: FontWeight.w900,
              color: HeracleTheme.textBlack,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                status.split(' ')[0], // e.g. "Protein"
                style: TextStyle(
                  fontSize: 9, // Reduced from 10
                  fontWeight: FontWeight.w600,
                  color: HeracleTheme.textBlack.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 2),
              Text(
                status.split(' ')[1], // e.g. "over" or "left"
                style: TextStyle(
                  fontSize: 9, // Reduced from 10
                  fontWeight: isOver ? FontWeight.w800 : FontWeight.w600,
                  color: isOver
                      ? HeracleTheme.textBlack
                      : HeracleTheme.textBlack.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: SizedBox(
              width: 28, // Reduced from 36
              height: 28, // Reduced from 36
              child: CustomPaint(
                painter: _MacroRingPainter(
                  progress: progress,
                  activeColor: activeColor,
                  bgColor: bgColor,
                  strokeWidth: 3.5, // Reduced from 4.0
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: activeColor,
                    size: 10, // Reduced from 12
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroRingPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color bgColor;
  final double strokeWidth;

  _MacroRingPainter({
    required this.progress,
    required this.activeColor,
    required this.bgColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background ring
    canvas.drawCircle(center, radius, bgPaint);

    // Draw active arc (starts from top -90 degrees, sweeps right)
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_MacroRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.bgColor != bgColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
