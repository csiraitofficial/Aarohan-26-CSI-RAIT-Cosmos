import 'package:flutter/material.dart';
import 'package:mobile/models/user_vitals.dart';
import 'package:mobile/features/vitals/config/vital_thresholds.dart';

class SummaryCards extends StatelessWidget {
  final UserVitals vitals;

  const SummaryCards({super.key, required this.vitals});

  @override
  Widget build(BuildContext context) {
    final cards = <_SummaryData>[];

    // Heart Rate
    if (vitals.heartRates.isNotEmpty) {
      final val = vitals.heartRates.first.value.toDouble();
      final trend = _calcTrend(
        vitals.heartRates.map((r) => r.value.toDouble()).toList(),
      );
      cards.add(_SummaryData(
        icon: Icons.favorite,
        label: 'Heart Rate',
        value: '${val.toInt()}',
        unit: 'bpm',
        color: VitalThresholds.getZoneColor(val, VitalThresholds.heartRateZones()),
        trend: trend,
      ));
    }

    // Blood Pressure
    if (vitals.bloodPressures.isNotEmpty) {
      final bp = vitals.bloodPressures.first;
      final color = VitalThresholds.getZoneColor(
        bp.systolic.toDouble(),
        VitalThresholds.bpSystolicZones(),
      );
      cards.add(_SummaryData(
        icon: Icons.speed,
        label: 'Blood Pressure',
        value: '${bp.systolic}/${bp.diastolic}',
        unit: 'mmHg',
        color: color,
        trend: _calcTrend(
          vitals.bloodPressures.map((r) => r.systolic.toDouble()).toList(),
        ),
      ));
    }

    // Glucose
    if (vitals.bloodGlucose.isNotEmpty) {
      final val = vitals.bloodGlucose.first.value;
      cards.add(_SummaryData(
        icon: Icons.bloodtype,
        label: 'Glucose',
        value: val.toStringAsFixed(0),
        unit: 'mg/dL',
        color: VitalThresholds.getZoneColor(val, VitalThresholds.glucoseZones()),
        trend: _calcTrend(
          vitals.bloodGlucose.map((r) => r.value).toList(),
        ),
      ));
    }

    // Steps
    cards.add(_SummaryData(
      icon: Icons.directions_walk,
      label: 'Steps',
      value: '${vitals.todaySteps}',
      unit: '',
      color: vitals.todaySteps >= VitalThresholds.stepsGreen
          ? const Color(0xFF4CAF50)
          : vitals.todaySteps >= VitalThresholds.stepsYellow
              ? const Color(0xFFFFC107)
              : const Color(0xFFF44336),
      trend: 0,
    ));

    // Calories
    cards.add(_SummaryData(
      icon: Icons.local_fire_department,
      label: 'Calories',
      value: vitals.todayCalories.toStringAsFixed(0),
      unit: 'kcal',
      color: vitals.todayCalories >= VitalThresholds.caloriesGreen
          ? const Color(0xFF4CAF50)
          : vitals.todayCalories >= VitalThresholds.caloriesYellow
              ? const Color(0xFFFFC107)
              : const Color(0xFFF44336),
      trend: 0,
    ));

    // Sleep
    final sleepHrs = vitals.todaySleepMinutes / 60.0;
    cards.add(_SummaryData(
      icon: Icons.nights_stay,
      label: 'Sleep',
      value: sleepHrs.toStringAsFixed(1),
      unit: 'hrs',
      color: vitals.todaySleepMinutes >= VitalThresholds.sleepGreenMin
          ? const Color(0xFF4CAF50)
          : vitals.todaySleepMinutes >= VitalThresholds.sleepYellowMin
              ? const Color(0xFFFFC107)
              : const Color(0xFFF44336),
      trend: 0,
    ));

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: cards.length,
        separatorBuilder: (context2, index) => const SizedBox(width: 10),
        itemBuilder: (context, i) => _SummaryCard(data: cards[i]),
      ),
    );
  }

  // Returns 1 (up), -1 (down), or 0 (stable)
  int _calcTrend(List<double> values) {
    if (values.length < 2) return 0;
    final latest = values.first;
    final avg = values.skip(1).take(5).fold(0.0, (a, b) => a + b) /
        values.skip(1).take(5).length;
    final pctChange = ((latest - avg) / avg).abs();
    if (pctChange < 0.05) return 0;
    return latest > avg ? 1 : -1;
  }
}

class _SummaryData {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;
  final int trend; // 1=up, -1=down, 0=stable

  const _SummaryData({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.trend,
  });
}

class _SummaryCard extends StatelessWidget {
  final _SummaryData data;
  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.color.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: data.color.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data.icon, size: 16, color: data.color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  data.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  data.value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: data.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (data.unit.isNotEmpty) ...[
                const SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    data.unit,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (data.trend != 0) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  data.trend > 0 ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: data.trend > 0 ? Colors.red.shade400 : Colors.green.shade400,
                ),
                const SizedBox(width: 2),
                Text(
                  data.trend > 0 ? 'Rising' : 'Falling',
                  style: TextStyle(
                    fontSize: 10,
                    color: data.trend > 0 ? Colors.red.shade400 : Colors.green.shade400,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
