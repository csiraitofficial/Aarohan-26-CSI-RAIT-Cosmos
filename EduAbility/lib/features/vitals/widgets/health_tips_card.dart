import 'package:flutter/material.dart';
import 'package:mobile/models/user_vitals.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/features/vitals/config/health_tips_data.dart';
import 'package:mobile/features/vitals/config/vital_thresholds.dart';

class HealthTipsCard extends StatelessWidget {
  final UserVitals vitals;

  const HealthTipsCard({super.key, required this.vitals});

  @override
  Widget build(BuildContext context) {
    final categories = ApiService.healthCategories;
    final tips = HealthTipsData.getTipsForUser(
      categories.isEmpty ? ['general'] : categories,
    );

    // Check for alert conditions
    final alerts = <String>[];
    if (vitals.heartRates.isNotEmpty) {
      final hr = vitals.heartRates.first.value.toDouble();
      final zones = VitalThresholds.heartRateZones();
      final color = VitalThresholds.getZoneColor(hr, zones);
      if (color == const Color(0xFFF44336)) {
        if (hr > 100) {
          alerts.addAll(HealthTipsData.alertTips['high_hr'] ?? []);
        } else {
          alerts.addAll(HealthTipsData.alertTips['low_hr'] ?? []);
        }
      }
    }

    if (vitals.bloodPressures.isNotEmpty) {
      final sys = vitals.bloodPressures.first.systolic.toDouble();
      final color = VitalThresholds.getZoneColor(sys, VitalThresholds.bpSystolicZones());
      if (color == const Color(0xFFF44336)) {
        alerts.addAll(HealthTipsData.alertTips['high_bp'] ?? []);
      }
    }

    if (vitals.bloodGlucose.isNotEmpty) {
      final glu = vitals.bloodGlucose.first.value;
      final zones = VitalThresholds.glucoseZones();
      final color = VitalThresholds.getZoneColor(glu, zones);
      if (color == const Color(0xFFF44336)) {
        if (glu > 125) {
          alerts.addAll(HealthTipsData.alertTips['high_glucose'] ?? []);
        } else {
          alerts.addAll(HealthTipsData.alertTips['low_glucose'] ?? []);
        }
      }
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  alerts.isNotEmpty ? Icons.warning_amber : Icons.lightbulb_outline,
                  color: alerts.isNotEmpty ? Colors.red : Colors.amber.shade700,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  alerts.isNotEmpty ? 'Health Alerts' : 'Health Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: alerts.isNotEmpty ? Colors.red : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Show alerts first (if any)
            if (alerts.isNotEmpty) ...[
              ...alerts.take(2).map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 18, color: Colors.red.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          alert,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              const Divider(height: 16),
            ],
            // Regular tips
            ...tips.take(3).map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    size: 16,
                    color: Colors.amber.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
