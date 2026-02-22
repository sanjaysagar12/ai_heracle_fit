import 'package:ai_heracle_fit/core/models/workout_session.dart';

enum AiResponseType { reply, workout }

class AiResponse {
  final AiResponseType type;
  final String? widget;
  final String message;
  final WorkoutSession? data;

  AiResponse({
    required this.type,
    this.widget,
    required this.message,
    this.data,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      type: json['type'] == 'workout'
          ? AiResponseType.workout
          : AiResponseType.reply,
      widget: json['widget'] as String?,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? WorkoutSession.fromJson(json['data']) : null,
    );
  }
}
