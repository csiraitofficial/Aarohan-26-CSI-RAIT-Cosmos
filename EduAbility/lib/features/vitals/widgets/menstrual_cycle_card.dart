import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/services/api_service.dart';

class MenstrualCycleCard extends StatelessWidget {
  const MenstrualCycleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final lastPeriod = ApiService.lastPeriodDate ?? DateTime.now().subtract(const Duration(days: 14));
    final cycleLen = ApiService.menstrualCycleLength;
    final periodDuration = ApiService.menstrualPeriodDuration;

    final daysSincePeriod = DateTime.now().difference(lastPeriod).inDays % cycleLen;
    final currentDay = daysSincePeriod + 1;

    // Phases
    final menstrualEnd = periodDuration;
    final follicularEnd = (cycleLen * 0.5).round();
    final ovulationEnd = follicularEnd + 2;
    final lutealEnd = cycleLen;

    String currentPhase;
    Color phaseColor;
    if (currentDay <= menstrualEnd) {
      currentPhase = 'Menstrual';
      phaseColor = const Color(0xFFF44336);
    } else if (currentDay <= follicularEnd) {
      currentPhase = 'Follicular';
      phaseColor = const Color(0xFFFF9800);
    } else if (currentDay <= ovulationEnd) {
      currentPhase = 'Ovulation';
      phaseColor = const Color(0xFF4CAF50);
    } else {
      currentPhase = 'Luteal';
      phaseColor = const Color(0xFF9C27B0);
    }

    final data = [
      _PhaseData('Menstrual', menstrualEnd.toDouble(), const Color(0xFFF44336)),
      _PhaseData('Follicular', (follicularEnd - menstrualEnd).toDouble(), const Color(0xFFFF9800)),
      _PhaseData('Ovulation', (ovulationEnd - follicularEnd).toDouble(), const Color(0xFF4CAF50)),
      _PhaseData('Luteal', (lutealEnd - ovulationEnd).toDouble(), const Color(0xFF9C27B0)),
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
              'Menstrual Cycle',
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
                      annotations: <CircularChartAnnotation>[
                        CircularChartAnnotation(
                          widget: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Day $currentDay',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: phaseColor,
                                ),
                              ),
                              Text(
                                'of $cycleLen',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      series: <CircularSeries<_PhaseData, String>>[
                        DoughnutSeries<_PhaseData, String>(
                          dataSource: data,
                          xValueMapper: (d, _) => d.label,
                          yValueMapper: (d, _) => d.days,
                          pointColorMapper: (d, _) => d.color,
                          radius: '90%',
                          innerRadius: '65%',
                          strokeWidth: 2,
                          strokeColor: Colors.white,
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
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: phaseColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentPhase,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: phaseColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...data.map(
                          (d) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: d.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  d.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

class _PhaseData {
  final String label;
  final double days;
  final Color color;
  const _PhaseData(this.label, this.days, this.color);
}
