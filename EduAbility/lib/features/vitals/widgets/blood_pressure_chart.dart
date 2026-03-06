import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/blood_pressure_reading.dart';
import 'package:mobile/features/vitals/config/vital_thresholds.dart';

class BloodPressureChart extends StatelessWidget {
  final List<BloodPressureReading> readings;

  const BloodPressureChart({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return _emptyCard(context);
    }

    final data = readings.reversed.toList();
    final zones = VitalThresholds.bpSystolicZones();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Pressure Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 50,
                  maximum: 200,
                  plotBands: zones
                      .map((z) => PlotBand(
                            start: z.min,
                            end: z.max,
                            color: z.color.withAlpha(25),
                          ))
                      .toList(),
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                ),
                series: <CartesianSeries<BloodPressureReading, DateTime>>[
                  SplineSeries<BloodPressureReading, DateTime>(
                    name: 'Systolic',
                    dataSource: data,
                    xValueMapper: (r, _) => r.timestamp,
                    yValueMapper: (r, _) => r.systolic,
                    color: Colors.red.shade500,
                    width: 2.5,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 6,
                      width: 6,
                    ),
                  ),
                  SplineSeries<BloodPressureReading, DateTime>(
                    name: 'Diastolic',
                    dataSource: data,
                    xValueMapper: (r, _) => r.timestamp,
                    yValueMapper: (r, _) => r.diastolic,
                    color: Colors.blue.shade400,
                    width: 2.5,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      height: 6,
                      width: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.speed, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'No blood pressure data',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
