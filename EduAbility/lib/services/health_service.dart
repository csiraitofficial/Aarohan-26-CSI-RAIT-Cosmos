import 'package:health/health.dart';
import 'package:mobile/models/blood_pressure_reading.dart';
import 'package:mobile/models/user_vitals.dart';
import 'package:mobile/models/vital_reading.dart';

class HealthService {
  final Health _health = Health();

  // Define the required types
  final List<HealthDataType> _types = [
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.WORKOUT,
  ];

  Future<UserVitals?> fetchAllVitals({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      // 1. Configure the plugin (required in newer versions)
      await _health.configure();

      // 2. Request Authorization
      try {
        bool? hasPermissions = await _health.hasPermissions(_types);
        if (hasPermissions == null || !hasPermissions) {
          bool authorized = await _health.requestAuthorization(_types);
          if (!authorized) {
            print("Health permissions not granted or user denied.");
            return null;
          }
        }
      } catch (authError) {
        print(
          "Authorization error. Health Connect might not be installed: $authError",
        );
        return null;
      }

      // 3. Fetch raw data
      List<HealthDataPoint> rawData = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: startTime,
        endTime: endTime,
      );
      rawData = _health.removeDuplicates(rawData);

      // 4. Use getTotalStepsInInterval for accurate step count
      //    (Health Connect merges all sources natively)
      int? totalSteps;
      try {
        totalSteps = await _health.getTotalStepsInInterval(startTime, endTime);
      } catch (e) {
        print("Error fetching aggregated steps: $e");
      }

      // 5. Parse raw data
      List<VitalReading<int>> heartRates = [];
      List<VitalReading<double>> bloodGlucose = [];
      Map<DateTime, int> systolicMap = {};
      Map<DateTime, int> diastolicMap = {};

      // Group calories by source to pick the most accurate one
      Map<String, double> caloriesBySource = {};
      int totalSleepMinutes = 0;
      int totalActiveMinutes = 0;

      for (var point in rawData) {
        final timestamp = point.dateFrom;
        switch (point.type) {
          case HealthDataType.HEART_RATE:
            final value = (point.value as NumericHealthValue).numericValue
                .toInt();
            heartRates.add(VitalReading(timestamp, value));
            break;

          case HealthDataType.BLOOD_GLUCOSE:
            final value = (point.value as NumericHealthValue).numericValue
                .toDouble();
            bloodGlucose.add(VitalReading(timestamp, value));
            break;

          case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
            systolicMap[timestamp] = (point.value as NumericHealthValue)
                .numericValue
                .toInt();
            break;

          case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
            diastolicMap[timestamp] = (point.value as NumericHealthValue)
                .numericValue
                .toInt();
            break;

          case HealthDataType.ACTIVE_ENERGY_BURNED:
            final cal = (point.value as NumericHealthValue)
                .numericValue
                .toDouble();
            caloriesBySource[point.sourceName] =
                (caloriesBySource[point.sourceName] ?? 0.0) + cal;
            break;

          case HealthDataType.SLEEP_SESSION:
            totalSleepMinutes +=
                point.dateTo.difference(point.dateFrom).inMinutes;
            break;

          case HealthDataType.WORKOUT:
            final minutes = point.dateTo.difference(point.dateFrom).inMinutes;
            totalActiveMinutes += minutes;
            break;

          default:
            break;
        }
      }

      // 6. For calories: pick the source with the lowest non-zero total.
      //    The inflated total comes from multiple sources stacking up;
      //    the lowest one is typically the single real device (e.g. OnePlus watch).
      double totalCalories = 0.0;
      if (caloriesBySource.isNotEmpty) {
        final nonZero = caloriesBySource.values.where((v) => v > 0);
        if (nonZero.isNotEmpty) {
          totalCalories = nonZero.reduce((a, b) => a < b ? a : b);
        }
      }

      // 7. Re-assemble Blood Pressure pairs
      List<BloodPressureReading> bloodPressures = [];
      systolicMap.forEach((time, sysValue) {
        if (diastolicMap.containsKey(time)) {
          bloodPressures.add(
            BloodPressureReading(
              timestamp: time,
              systolic: sysValue,
              diastolic: diastolicMap[time]!,
            ),
          );
        }
      });

      // Sort point-in-time readings chronologically (newest first)
      heartRates.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      bloodGlucose.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      bloodPressures.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final now = DateTime.now();

      // 9. Return clean data
      return UserVitals(
        heartRates: heartRates,
        bloodPressures: bloodPressures,
        bloodGlucose: bloodGlucose,
        sleepSessionsMinutes: [
          if (totalSleepMinutes > 0)
            VitalReading(now, totalSleepMinutes),
        ],
        steps: [
          if (totalSteps != null && totalSteps > 0)
            VitalReading(now, totalSteps),
        ],
        caloriesBurned: [
          if (totalCalories > 0)
            VitalReading(now, totalCalories),
        ],
        activeMinutes: [
          if (totalActiveMinutes > 0)
            VitalReading(now, totalActiveMinutes),
        ],
      );
    } catch (e) {
      print("Error fetching vitals: $e");
      return null;
    }
  }

  /// Generate rich demo vitals in-memory (no Health Connect needed).
  static UserVitals generateDemoVitals() {
    final now = DateTime.now();
    final seed = now.millisecondsSinceEpoch;

    // Heart rate: 24 hourly readings
    final heartRates = List.generate(24, (i) {
      final ts = now.subtract(Duration(hours: 23 - i));
      int base = (i < 7 || i > 22) ? 62 : 78;
      int val = base + ((seed + i * 17) % 20) - 10;
      return VitalReading<int>(ts, val.clamp(50, 130));
    });

    // Blood pressure: 8 readings
    final bloodPressures = List.generate(8, (i) {
      final ts = now.subtract(Duration(hours: (7 - i) * 3));
      int sys = 118 + ((seed + i * 23) % 20) - 10;
      int dia = 76 + ((seed + i * 31) % 14) - 7;
      return BloodPressureReading(
        timestamp: ts,
        systolic: sys.clamp(90, 160),
        diastolic: dia.clamp(60, 100),
      );
    });

    // Glucose: 10 readings with post-meal spikes
    final bloodGlucose = List.generate(10, (i) {
      final ts = now.subtract(Duration(hours: (9 - i) * 2 + 1));
      double base = (i == 2 || i == 5 || i == 8) ? 130.0 : 92.0;
      double val = base + ((seed + i * 41) % 20) - 10;
      return VitalReading<double>(ts, val.clamp(55.0, 250.0));
    });

    // Sleep: 7 days
    final sleepSessions = List.generate(7, (i) {
      final ts = now.subtract(Duration(days: 6 - i));
      int mins = 360 + ((seed + i * 53) % 180);
      return VitalReading<int>(ts, mins.clamp(240, 600));
    });

    final steps = [VitalReading<int>(now, 6500 + (seed % 4000))];
    final calories = [VitalReading<double>(now, 250.0 + (seed % 200))];
    final activeMinutes = [VitalReading<int>(now, 25 + (seed % 40))];

    // Sort newest first
    heartRates.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    bloodPressures.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    bloodGlucose.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    sleepSessions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return UserVitals(
      heartRates: heartRates,
      bloodPressures: bloodPressures,
      bloodGlucose: bloodGlucose,
      sleepSessionsMinutes: sleepSessions,
      steps: steps,
      caloriesBurned: calories,
      activeMinutes: activeMinutes,
    );
  }

  Future<bool> writeMockData() async {
    final now = DateTime.now();
    try {
      bool sysSuccess = await _health.writeHealthData(
        value: 120,
        type: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now,
      );
      bool diaSuccess = await _health.writeHealthData(
        value: 80,
        type: HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now,
      );
      bool bgSuccess = await _health.writeHealthData(
        value: 95.5,
        type: HealthDataType.BLOOD_GLUCOSE,
        startTime: now.subtract(const Duration(hours: 2)),
        endTime: now,
      );
      bool sleepSuccess = await _health.writeHealthData(
        value: 480, // 8 hours in minutes
        type: HealthDataType.SLEEP_SESSION,
        startTime: now.subtract(const Duration(hours: 10)),
        endTime: now.subtract(const Duration(hours: 2)),
      );
      bool stepsSuccess = await _health.writeHealthData(
        value: 5000,
        type: HealthDataType.STEPS,
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now,
      );
      bool caloriesSuccess = await _health.writeHealthData(
        value: 350.5,
        type: HealthDataType.ACTIVE_ENERGY_BURNED,
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now,
      );

      return sysSuccess &&
          diaSuccess &&
          bgSuccess &&
          sleepSuccess &&
          stepsSuccess &&
          caloriesSuccess;
    } catch (e) {
      print("Error writing mock data: $e");
      return false;
    }
  }
}
