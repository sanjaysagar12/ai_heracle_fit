import 'package:flutter/material.dart';
import 'package:ai_heracle_fit/core/theme.dart';
import 'package:ai_heracle_fit/core/models/tracked_food.dart';
import 'package:ai_heracle_fit/core/models/logged_meal.dart';
import 'package:ai_heracle_fit/core/models/diet_status.dart';
import 'package:ai_heracle_fit/core/models/diet_suggestion.dart';
import 'package:ai_heracle_fit/core/services/diet_service.dart';
import 'package:ai_heracle_fit/page/diet_planning/diet_plan_model.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';

class DietPlanningScreen extends StatefulWidget {
  const DietPlanningScreen({super.key});

  @override
  State<DietPlanningScreen> createState() => _DietPlanningScreenState();
}

class _DietPlanningScreenState extends State<DietPlanningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _aiFoodController = TextEditingController();
  bool _isAiLoading = false;
  String _selectedMealType = 'Breakfast';

  final List<TrackedFood> _scannedPreviewMeals = [];

  List<LoggedMeal> _trackedMeals = [];
  DietStatus? _dietStatus;
  DietSuggestion? _aiSuggestion;

  String _getDefaultMealType() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return 'Breakfast';
    if (hour >= 11 && hour < 16) return 'Lunch';
    if (hour >= 16 && hour < 19) return 'Snacks';
    return 'Dinner';
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedMealType = _getDefaultMealType();
    _loadLoggedMeals();
  }

  Future<void> _loadLoggedMeals() async {
    final meals = await DietService.instance.fetchMeals();
    final status = await DietService.instance.fetchDietStatus();
    final suggestion = await DietService.instance.fetchTodayDiet();
    setState(() {
      _trackedMeals = meals;
      _dietStatus = status;
      _aiSuggestion = suggestion;
    });
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
            child: _isAiLoading
                ? const SizedBox(
                    width: 48,
                    height: 48,
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      final input = _aiFoodController.text.trim();
                      if (input.isNotEmpty) {
                        setState(() => _isAiLoading = true);
                        try {
                          final result = await DietService.instance.analyzeFood(
                            input,
                          );
                          if (result != null) {
                            setState(() {
                              result.mealType = _selectedMealType;
                              _scannedPreviewMeals.insert(0, result);
                              _aiFoodController.clear();
                            });
                          } else {
                            // Show error snackbar
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Failed to analyze food. Please try again.',
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        } finally {
                          if (mounted) {
                            setState(() => _isAiLoading = false);
                          }
                        }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: HeracleTheme.givingliGreenDark.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMealType,
                    isDense: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: HeracleTheme.givingliGreenDark,
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: HeracleTheme.givingliGreenDark,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedMealType = newValue;
                          for (var meal in _scannedPreviewMeals) {
                            meal.mealType = newValue;
                          }
                        });
                      }
                    },
                    items: <String>['Breakfast', 'Lunch', 'Snacks', 'Dinner']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._scannedPreviewMeals.asMap().entries.map((entry) {
            final int index = entry.key;
            final TrackedFood previewMeal = entry.value;

            return Container(
              key: ObjectKey(previewMeal),
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
              onPressed: () async {
                if (_scannedPreviewMeals.isEmpty) return;

                final now = DateTime.now();
                final newMeal = LoggedMeal(
                  mealType: _selectedMealType,
                  date: DateFormat('yyyy-MM-dd').format(now),
                  time: DateFormat('HH:mm').format(now),
                  data: List.from(_scannedPreviewMeals),
                );

                setState(() => _isAiLoading = true);
                try {
                  final saved = await DietService.instance.logMeal(newMeal);
                  if (saved != null) {
                    setState(() {
                      _trackedMeals.insert(0, saved);
                      _scannedPreviewMeals.clear();
                    });
                    _loadLoggedMeals(); // Refresh status as well
                  }
                } finally {
                  setState(() => _isAiLoading = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HeracleTheme.textBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isAiLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
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
            LoggedMeal meal = entry.value;
            return _buildLoggedMealCard(meal, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLoggedMealCard(LoggedMeal meal, int index) {
    // Sum macros for the whole meal
    int totalCals = meal.data.fold(0, (sum, f) => sum + f.calories);

    return Container(
      key: ObjectKey(meal),
      margin: const EdgeInsets.only(bottom: 12),
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
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: HeracleTheme.givingliGreenDark.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      meal.mealType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: HeracleTheme.givingliGreenDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    meal.time,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: HeracleTheme.textGrey,
                    ),
                  ),
                ],
              ),
              Text(
                '$totalCals kcal',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: HeracleTheme.textBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...meal.data
              .map(
                (food) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          food.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: HeracleTheme.textBlack,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${food.protein}P • ${food.carbs}C • ${food.fats}F',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: HeracleTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
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
                      // TAB 1: Track Calories (Matched to Screenshot UI)
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

                      // TAB 2: Diet Plan
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
                            if (_aiSuggestion != null &&
                                _aiSuggestion!.suggestedMeal.isNotEmpty) ...[
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
                                'Based on your protein and calorie targets for today.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: HeracleTheme.textGrey.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 24),
                              ..._aiSuggestion!.suggestedMeal.map(
                                (item) => _buildSuggestedMealCard(item),
                              ),
                            ] else if (_aiSuggestion == null) ...[
                              // Loading state for suggested meals
                              const Center(child: CircularProgressIndicator()),
                            ] else ...[
                              const Text(
                                'Trending Diet Plans',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: HeracleTheme.textBlack,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ...mockDietPlans.map(
                                (plan) => _buildDietPlanCard(plan),
                              ),
                            ],
                            const SizedBox(height: 40),
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
            Tab(text: 'Track'),
            Tab(text: 'Plan'),
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
    if (_aiSuggestion == null) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1D1B20),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: HeracleTheme.givingliGreen),
        ),
      );
    }

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
                _buildAiInsightTag(),
                const SizedBox(height: 20),
                TypingTextAnimation(
                  text: _aiSuggestion!.suggestion,
                  parser: _parseBracedText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsightTag() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: HeracleTheme.givingliGreenDark.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: HeracleTheme.givingliGreenDark.withOpacity(0.3),
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
    );
  }

  Widget _buildSuggestedMealCard(SuggestedMealItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: HeracleTheme.bgBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _getPurposeIcon(item.purpose),
              color: HeracleTheme.textBlack,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: HeracleTheme.textBlack,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.purpose,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: HeracleTheme.givingliGreenDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: HeracleTheme.textGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${item.calories} kcal',
                      style: const TextStyle(
                        fontSize: 12,
                        color: HeracleTheme.textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Macros Row
                Row(
                  children: [
                    _buildMealMacroStat('P', '${item.protein}g'),
                    const SizedBox(width: 12),
                    _buildMealMacroStat('C', '${item.carbs}g'),
                    const SizedBox(width: 12),
                    _buildMealMacroStat('F', '${item.fat}g'),
                    const SizedBox(width: 12),
                    _buildMealMacroStat('Fi', '${item.fiber}g'),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: HeracleTheme.textGrey),
        ],
      ),
    );
  }

  Widget _buildMealMacroStat(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: HeracleTheme.textBlack.withOpacity(0.5),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: HeracleTheme.textBlack,
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
                    _buildMealMacroStat('Calories', '${plan.calories}kcal'),
                    const SizedBox(width: 8),
                    _buildMealMacroStat('Protein', '${plan.protein}g'),
                    const SizedBox(width: 8),
                    _buildMealMacroStat('Carbs', '${plan.carbs}g'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── AI Suggestion Helpers ──────────────────────────────────────────────────

  List<TextSpan> _parseBracedText(String text) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'\{([^}]+)\}');
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return spans;
  }

  IconData _getPurposeIcon(String purpose) {
    final p = purpose.toLowerCase();
    if (p.contains('protein')) return Icons.egg_rounded;
    if (p.contains('carb')) return Icons.bakery_dining_rounded;
    if (p.contains('fat')) return Icons.water_drop_rounded;
    if (p.contains('fiber')) return Icons.eco_rounded;
    if (p.contains('energy') || p.contains('cal')) return Icons.bolt_rounded;
    return Icons.restaurant_rounded;
  }

  // ── Tab 2 Widgets (Screenshot implementation) ───────────────────────────────

  Widget _buildDailyMacroSummary() {
    // If we have API data, use it; otherwise fallback to local calculation
    int totalCals =
        _dietStatus?.consumed.calories.toInt() ??
        _trackedMeals.fold(
          0,
          (sum, m) => sum + m.data.fold(0, (s, f) => s + f.calories),
        );
    int totalProtein =
        _dietStatus?.consumed.protein.toInt() ??
        _trackedMeals.fold(
          0,
          (sum, m) => sum + m.data.fold(0, (s, f) => s + f.protein),
        );
    int totalCarbs =
        _dietStatus?.consumed.carbs.toInt() ??
        _trackedMeals.fold(
          0,
          (sum, m) => sum + m.data.fold(0, (s, f) => s + f.carbs),
        );
    int totalFats =
        _dietStatus?.consumed.fat.toInt() ??
        _trackedMeals.fold(
          0,
          (sum, m) => sum + m.data.fold(0, (s, f) => s + f.fats),
        );
    int totalFiber =
        _dietStatus?.consumed.fiber.toInt() ??
        _trackedMeals.fold(
          0,
          (sum, m) => sum + m.data.fold(0, (s, f) => s + f.fiber),
        );

    // Targets from API
    int goalCals = _dietStatus?.targets.calories.toInt() ?? 2400;
    int goalProtein = _dietStatus?.targets.protein.toInt() ?? 180;
    int goalCarbs = _dietStatus?.targets.carbs.toInt() ?? 250;
    int goalFats = _dietStatus?.targets.fat.toInt() ?? 70;
    int goalFiber = _dietStatus?.targets.fiber.toInt() ?? 30;

    String calsStatus = "$totalCals / $goalCals kcal";

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
                    '$totalCals',
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
                value: '${totalProtein}g',
                status: '/ ${goalProtein}g',
                progress: proteinProgress,
                activeColor: const Color(0xFFE55A6B),
                bgColor: const Color(0xFFE55A6B).withOpacity(0.12),
                icon: Icons.fastfood_rounded,
                isOver: totalProtein > goalProtein,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallMacroCard(
                value: '${totalCarbs}g',
                status: '/ ${goalCarbs}g',
                progress: carbsProgress,
                activeColor: const Color(0xFFF39C12),
                bgColor: const Color(0xFFF39C12).withOpacity(0.12),
                icon: Icons.grain_rounded,
                isOver: totalCarbs > goalCarbs,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallMacroCard(
                value: '${totalFats}g',
                status: '/ ${goalFats}g',
                progress: fatsProgress,
                activeColor: const Color(0xFF4A90E2),
                bgColor: const Color(0xFF4A90E2).withOpacity(0.12),
                icon: Icons.water_drop_rounded,
                isOver: totalFats > goalFats,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSmallMacroCard(
                value: '${totalFiber}g',
                status: '/ ${goalFiber}g',
                progress: fiberProgress,
                activeColor: HeracleTheme.givingliGreenDark,
                bgColor: HeracleTheme.givingliGreenDark.withOpacity(0.12),
                icon: Icons.eco_rounded,
                isOver: totalFiber > goalFiber,
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

// ── Typing Animation Widget ──────────────────────────────────────────────────

class TypingTextAnimation extends StatefulWidget {
  final String text;
  final List<TextSpan> Function(String) parser;
  final Duration duration;

  const TypingTextAnimation({
    super.key,
    required this.text,
    required this.parser,
    this.duration = const Duration(milliseconds: 20),
  });

  @override
  State<TypingTextAnimation> createState() => _TypingTextAnimationState();
}

class _TypingTextAnimationState extends State<TypingTextAnimation> {
  String _displayedText = '';
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didUpdateWidget(TypingTextAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer?.cancel();
    _displayedText = '';
    _currentIndex = 0;
    _timer = Timer.periodic(widget.duration, (timer) {
      if (_currentIndex < widget.text.length) {
        if (mounted) {
          setState(() {
            _displayedText += widget.text[_currentIndex];
            _currentIndex++;
          });
        }
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
    return RichText(
      text: TextSpan(
        children: widget.parser(_displayedText),
        style: const TextStyle(fontFamily: 'Outfit'), // Match app theme
      ),
    );
  }
}
