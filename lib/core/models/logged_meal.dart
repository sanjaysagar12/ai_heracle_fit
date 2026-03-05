import 'package:ai_heracle_fit/core/models/tracked_food.dart';

class LoggedMeal {
  final String? id;
  final String mealType;
  final String date;
  final String time;
  final List<TrackedFood> data;
  final DateTime? createdAt;

  LoggedMeal({
    this.id,
    required this.mealType,
    required this.date,
    required this.time,
    required this.data,
    this.createdAt,
  });

  factory LoggedMeal.fromJson(Map<String, dynamic> json) {
    return LoggedMeal(
      id: json['id'] as String?,
      mealType: json['mealType'] as String? ?? 'Other',
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => TrackedFood.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealType': mealType,
      'date': date,
      'time': time,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
