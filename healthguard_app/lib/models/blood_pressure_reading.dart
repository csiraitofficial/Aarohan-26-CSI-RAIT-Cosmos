class BloodPressureReading {
  final DateTime timestamp;
  final int systolic;
  final int diastolic;
  
  BloodPressureReading({
    required this.timestamp, 
    required this.systolic, 
    required this.diastolic
  });

  @override
  String toString() => "$systolic/$diastolic mmHg";
}
