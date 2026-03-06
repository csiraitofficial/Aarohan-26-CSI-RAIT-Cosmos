import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/vital_reading.dart';
import 'package:mobile/features/vitals/config/vital_thresholds.dart';
import 'package:mobile/services/api_service.dart';

class HeartRateChart extends StatelessWidget {
  final List<VitalReading<int>> readings;

  const HeartRateChart({super.key, required this.readings});

  String get _title {
    final cats = ApiService.healthCategories;
    if (cats.contains('anxiety')) return 'Stress Indicator (Heart Rate)';
    return 'Heart Rate Trend';
  }

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return _emptyCard(context);
    }

    final data = readings.reversed.toList();
    final zones = VitalThresholds.heartRateZones();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 40,
                  maximum: 180,
                  plotBands: zones
                      .map((z) => PlotBand(
                            start: z.min,
                            end: z.max,
                            color: z.color.withAlpha(30),
                          ))
                      .toList(),
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  activationMode: ActivationMode.singleTap,
                  tooltipSettings: const InteractiveTooltip(
                    format: 'point.y bpm',
                  ),
                ),
                series: <CartesianSeries<VitalReading<int>, DateTime>>[
                  SplineSeries<VitalReading<int>, DateTime>(
                    dataSource: data,
                    xValueMapper: (r, _) => r.timestamp,
                    yValueMapper: (r, _) => r.value,
                    color: Colors.red.shade400,
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
            Icon(Icons.favorite_border, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'No heart rate data',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
