import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/user_vitals.dart';

class SleepChart extends StatelessWidget {
  final UserVitals vitals;

  const SleepChart({super.key, required this.vitals});

  @override
  Widget build(BuildContext context) {
    final sleepHours = vitals.todaySleepMinutes / 60.0;

    // Build bar data — for demo we show a week of simulated data
    final now = DateTime.now();
    final data = <_SleepData>[];

    // If we have sleep session data, use it; otherwise show single bar
    if (vitals.sleepSessionsMinutes.length > 1) {
      for (final reading in vitals.sleepSessionsMinutes.reversed) {
        data.add(_SleepData(reading.timestamp, reading.value / 60.0));
      }
    } else {
      // Single day bar
      data.add(_SleepData(now, sleepHours));
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sleep',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${sleepHours.toStringAsFixed(1)} hours today',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 12,
                  plotBands: [
                    PlotBand(
                      start: 7,
                      end: 9,
                      color: const Color(0xFF4CAF50).withAlpha(25),
                      text: 'Goal',
                      textStyle: TextStyle(
                        fontSize: 10,
                        color: Colors.green.shade300,
                      ),
                    ),
                  ],
                ),
                series: <CartesianSeries<_SleepData, DateTime>>[
                  ColumnSeries<_SleepData, DateTime>(
                    dataSource: data,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.hours,
                    pointColorMapper: (d, _) => d.hours >= 7
                        ? const Color(0xFF3F51B5)
                        : d.hours >= 6
                            ? const Color(0xFFFFC107)
                            : const Color(0xFFF44336),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    width: 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SleepData {
  final DateTime date;
  final double hours;
  const _SleepData(this.date, this.hours);
}
