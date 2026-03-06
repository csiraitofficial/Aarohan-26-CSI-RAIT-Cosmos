import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/user_vitals.dart';
import 'package:mobile/features/vitals/config/vital_thresholds.dart';

class ActivityRings extends StatelessWidget {
  final UserVitals vitals;

  const ActivityRings({super.key, required this.vitals});

  @override
  Widget build(BuildContext context) {
    final stepsGoal = VitalThresholds.stepsGreen;
    final calGoal = VitalThresholds.caloriesGreen;
    final activeGoal = VitalThresholds.activeMinGreen;

    final stepsPct = (vitals.todaySteps / stepsGoal * 100).clamp(0, 150).toDouble();
    final calPct = (vitals.todayCalories / calGoal * 100).clamp(0, 150).toDouble();
    final activePct = (vitals.todayActiveMinutes / activeGoal * 100).clamp(0, 150).toDouble();

    final data = [
      _RingData('Steps', stepsPct, const Color(0xFF4CAF50),
          '${vitals.todaySteps}/$stepsGoal'),
      _RingData('Calories', calPct, const Color(0xFFFF9800),
          '${vitals.todayCalories.toInt()}/${calGoal.toInt()} kcal'),
      _RingData('Active', activePct, const Color(0xFF2196F3),
          '${vitals.todayActiveMinutes}/$activeGoal min'),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SfCircularChart(
                      margin: EdgeInsets.zero,
                      series: <CircularSeries<_RingData, String>>[
                        RadialBarSeries<_RingData, String>(
                          dataSource: data,
                          xValueMapper: (d, _) => d.label,
                          yValueMapper: (d, _) => d.percent,
                          pointColorMapper: (d, _) => d.color,
                          maximumValue: 100,
                          radius: '100%',
                          innerRadius: '30%',
                          gap: '8%',
                          trackColor: Colors.grey.shade200,
                          cornerStyle: CornerStyle.bothCurve,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data
                          .map(
                            (d) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: d.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          d.label,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                        Text(
                                          d.detail,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
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
}

class _RingData {
  final String label;
  final double percent;
  final Color color;
  final String detail;
  const _RingData(this.label, this.percent, this.color, this.detail);
}
