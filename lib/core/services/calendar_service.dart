class CalendarEvent {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool isTask;

  CalendarEvent({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.isTask = false,
  });

  Duration get duration => endTime.difference(startTime);
}

class CalendarService {
  Future<List<CalendarEvent>> getTodayEvents() async {
    // Mocking Google Calendar events
    final now = DateTime.now();
    return [
      CalendarEvent(
        title: 'Project Synchronization Meeting',
        startTime: DateTime(now.year, now.month, now.day, 10, 0),
        endTime: DateTime(now.year, now.month, now.day, 15, 0), // 5hr meeting
      ),
      CalendarEvent(
        title: 'Client Call',
        startTime: DateTime(now.year, now.month, now.day, 16, 0),
        endTime: DateTime(now.year, now.month, now.day, 17, 0),
      ),
    ];
  }
}
