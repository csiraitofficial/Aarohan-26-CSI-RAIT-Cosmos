class VitalReading<T> {
  final DateTime timestamp;
  final DateTime? endTime;
  final T value;
  VitalReading(this.timestamp, this.value, {this.endTime});
}
