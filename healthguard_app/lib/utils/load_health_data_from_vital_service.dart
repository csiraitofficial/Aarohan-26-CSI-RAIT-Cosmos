import 'package:mobile/models/user_vitals.dart';
import 'package:mobile/services/health_service.dart';

void loadVitalsDataFromHealthService() async {
  final service = HealthService();
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));

  UserVitals? vitals = await service.fetchAllVitals(
    startTime: yesterday,
    endTime: now,
  );

  if (vitals != null) {
    print("Latest Heart Rate: ${vitals.heartRates.firstOrNull?.value} bpm");
    print(
      "Latest Blood Pressure: ${vitals.bloodPressures.firstOrNull.toString()}",
    );
    // Update your state here...
  }
}
