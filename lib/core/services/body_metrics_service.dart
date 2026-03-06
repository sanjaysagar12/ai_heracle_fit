import 'package:ai_heracle_fit/core/models/body_metrics.dart';
import 'package:ai_heracle_fit/core/services/api_client.dart';

class BodyMetricsService {
  BodyMetricsService._();
  static final BodyMetricsService instance = BodyMetricsService._();

  /// POST /user/body-metrics
  /// Returns true on success.
  Future<bool> saveMetrics(BodyMetrics metrics) async {
    try {
      final response = await ApiClient.instance.post(
        '/user/body-metrics',
        data: metrics.toJson(),
      );
      final success = response.statusCode == 200 || response.statusCode == 201;
      if (success) {
        print('[BodyMetricsService] Metrics saved successfully.');
      } else {
        print(
          '[BodyMetricsService] Unexpected status ${response.statusCode}: ${response.data}',
        );
      }
      return success;
    } catch (e) {
      print('[BodyMetricsService] Error saving metrics: $e');
      return false;
    }
  }
}
