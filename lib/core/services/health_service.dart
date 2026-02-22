enum PeriodPhase {
  menstrual,
  follicular,
  ovulatory,
  luteal,
  none,
}

class HealthData {
  final PeriodPhase currentPhase;
  final int dayOfCycle;

  HealthData({
    required this.currentPhase,
    required this.dayOfCycle,
  });
}

class HealthService {
  Future<HealthData> getHealthData() async {
    // Mocking period cycle data
    return HealthData(
      currentPhase: PeriodPhase.luteal,
      dayOfCycle: 22,
    );
  }
}
