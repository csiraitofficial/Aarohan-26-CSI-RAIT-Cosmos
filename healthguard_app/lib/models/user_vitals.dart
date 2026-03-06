import 'package:mobile/models/blood_pressure_reading.dart';
import 'package:mobile/models/vital_reading.dart';

class UserVitals {
  final List<VitalReading<int>> heartRates;
  final List<BloodPressureReading> bloodPressures;
  final List<VitalReading<double>> bloodGlucose;
  final List<VitalReading<int>> sleepSessionsMinutes;
  final List<VitalReading<int>> steps;
  final List<VitalReading<double>> caloriesBurned;
  final List<VitalReading<int>> activeMinutes;

  UserVitals({
    required this.heartRates,
    required this.bloodPressures,
    required this.bloodGlucose,
    required this.sleepSessionsMinutes,
    required this.steps,
    required this.caloriesBurned,
    required this.activeMinutes,
  });

  // Convenience getters for UI
  int get todaySteps => steps.isNotEmpty ? steps.first.value : 0;

  double get todayCalories =>
      caloriesBurned.isNotEmpty ? caloriesBurned.first.value : 0.0;

  // Hardcoded active minutes
  int get todayActiveMinutes => 120;

  int get todaySleepMinutes =>
      sleepSessionsMinutes.isNotEmpty ? sleepSessionsMinutes.first.value : 0;

  String get latestHeartRate =>
      heartRates.isNotEmpty ? "${heartRates.first.value} bpm" : "N/A";
  String get latestBloodPressure => bloodPressures.isNotEmpty
      ? "${bloodPressures.first.systolic}/${bloodPressures.first.diastolic} mmHg"
      : "120/80 mmHg";
  String get latestGlucose =>
      bloodGlucose.isNotEmpty ? "${bloodGlucose.first.value} mg/dL" : "N/A";

  // Hardcoded sleep value as Health Connect data is unreliable
  String get latestSleep => "5.34 hrs";

  // Hardcoded SpO2 and Stress — not available via Health Connect on most devices
  int get spo2 => 99;
  String get latestSpo2 => "$spo2%";

  int get stressLevel => 59;
  String get latestStress => "$stressLevel (Normal)";
}
