import 'calendar_service.dart';
import 'health_service.dart';

class Suggestion {
  final String message;
  final String actionLabel;

  Suggestion({required this.message, required this.actionLabel});
}

class SuggestionService {
  final CalendarService _calendarService = CalendarService();
  final HealthService _healthService = HealthService();

  Future<Suggestion> getContextualSuggestion() async {
    final events = await _calendarService.getTodayEvents();
    final healthData = await _healthService.getHealthData();

    // Logic for long meeting suggestion
    final longMeeting = events.firstWhere(
      (e) => e.duration >= const Duration(hours: 4),
      orElse: () => events.first, // Just for mock variety
    );

    String message = '';
    
    if (longMeeting.duration >= const Duration(hours: 4)) {
      message = "You have a ${longMeeting.duration.inHours}hr meeting today which might drain you so here's a quick biceps session to not lose consistency";
    } else if (healthData.currentPhase == PeriodPhase.luteal) {
       message = "You're in your luteal phase, energy might be lower. Let's try a gentle yoga session today.";
    } else {
      message = "Your schedule looks clear! Time for a high-intensity session?";
    }

    return Suggestion(
      message: message,
      actionLabel: "View session",
    );
  }
}
