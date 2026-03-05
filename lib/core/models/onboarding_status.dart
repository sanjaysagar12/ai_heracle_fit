class OnboardingStatus {
  final bool bodyMetricsNeeded;
  final bool dietDataNeeded;

  OnboardingStatus({
    required this.bodyMetricsNeeded,
    required this.dietDataNeeded,
  });

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) {
    return OnboardingStatus(
      bodyMetricsNeeded: json['bodyMetricsNeeded'] ?? false,
      dietDataNeeded: json['dietDataNeeded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyMetricsNeeded': bodyMetricsNeeded,
      'dietDataNeeded': dietDataNeeded,
    };
  }
}
