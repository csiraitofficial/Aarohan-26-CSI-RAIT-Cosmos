import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/models/user_vitals.dart';
import 'package:mobile/models/risk_result.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/disability_provider.dart';
import 'package:mobile/features/vitals/config/category_layout.dart';
import 'package:mobile/features/vitals/widgets/risk_score_gauge.dart';
import 'package:mobile/features/vitals/widgets/summary_cards.dart';
import 'package:mobile/features/vitals/widgets/heart_rate_chart.dart';
import 'package:mobile/features/vitals/widgets/blood_pressure_chart.dart';
import 'package:mobile/features/vitals/widgets/glucose_chart.dart';
import 'package:mobile/features/vitals/widgets/activity_rings.dart';
import 'package:mobile/features/vitals/widgets/sleep_chart.dart';
import 'package:mobile/features/vitals/widgets/menstrual_cycle_card.dart';
import 'package:mobile/features/vitals/widgets/health_tips_card.dart';
import 'package:mobile/features/vitals/widgets/sensory_event_chart.dart';
import 'package:mobile/features/vitals/widgets/routine_adherence_chart.dart';
import 'package:mobile/features/vitals/widgets/focus_session_chart.dart';
import 'package:mobile/features/vitals/widgets/task_completion_chart.dart';
import 'package:mobile/features/vitals/widgets/reading_session_chart.dart';
import 'package:mobile/features/vitals/widgets/word_fluency_chart.dart';
import 'package:mobile/features/vitals/widgets/communication_log_chart.dart';
import 'package:mobile/features/vitals/widgets/sign_practice_chart.dart';

class VitalsDashboardScreen extends StatelessWidget {
  final UserVitals vitals;
  final RiskResult? riskResult;

  const VitalsDashboardScreen({
    super.key,
    required this.vitals,
    this.riskResult,
  });

  @override
  Widget build(BuildContext context) {
    final disability = context.watch<DisabilityProvider>().disability;
    final sections = CategoryLayout.getSectionsForUser(disability: disability);
    final risk = riskResult ??
        RiskResult(
          userId: ApiService.currentUserId ?? '1',
          riskZone: _computeQuickZone(),
          riskScore: _computeQuickScore(),
          keyFactors: [],
          recommendedAction: '',
        );

    // Personalization header
    final categories = ApiService.healthCategories;
    final hasPersonalization = categories.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personalization badge
        if (hasPersonalization)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                Icon(Icons.tune, size: 16, color: Colors.teal.shade600),
                Text(
                  'Personalized for:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.teal.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ...categories.map((cat) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Text(
                    _formatCategory(cat),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
              ],
            ),
          ),

        // Render sections in personalized order
        ...sections.map((section) {
          switch (section) {
            case DashboardSection.riskGauge:
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RiskScoreGauge(
                  riskScore: risk.riskScore,
                  riskZone: risk.riskZone,
                ),
              );
            case DashboardSection.summaryCards:
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SummaryCards(vitals: vitals),
              );
            case DashboardSection.heartRateChart:
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HeartRateChart(readings: vitals.heartRates),
              );
            case DashboardSection.bloodPressureChart:
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BloodPressureChart(readings: vitals.bloodPressures),
              );
            case DashboardSection.glucoseChart:
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlucoseChart(readings: vitals.bloodGlucose),
              );
            case DashboardSection.activityRings:
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ActivityRings(vitals: vitals),
              );
            case DashboardSection.sleepChart:
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SleepChart(vitals: vitals),
              );
            case DashboardSection.menstrualCycleCard:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: MenstrualCycleCard(),
              );
            case DashboardSection.healthTips:
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HealthTipsCard(vitals: vitals),
              );
            case DashboardSection.sensoryEventChart:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SensoryEventChart(),
              );
            case DashboardSection.routineAdherenceChart:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: RoutineAdherenceChart(),
              );
            case DashboardSection.focusSessionChart:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: FocusSessionChart(),
              );
            case DashboardSection.taskCompletionChart:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: TaskCompletionChart(),
              );
            case DashboardSection.readingSessionChart:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: ReadingSessionChart(),
              );
            case DashboardSection.wordFluencyChart:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: WordFluencyChart(),
              );
            case DashboardSection.communicationLogChart:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: CommunicationLogChart(),
              );
            case DashboardSection.signPracticeChart:
              return const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SignPracticeChart(),
              );
          }
        }),
      ],
    );
  }

  String _computeQuickZone() {
    int sys = vitals.bloodPressures.isNotEmpty
        ? vitals.bloodPressures.first.systolic
        : 0;
    int hr = vitals.heartRates.isNotEmpty ? vitals.heartRates.first.value : 0;
    double glu = vitals.bloodGlucose.isNotEmpty
        ? vitals.bloodGlucose.first.value
        : 0;

    if (sys > 180 || hr > 120 || glu > 200) return 'red';
    if (sys > 140 || hr > 100 || glu > 140) return 'yellow';
    return 'green';
  }

  double _computeQuickScore() {
    final zone = _computeQuickZone();
    switch (zone) {
      case 'red':
        return 80;
      case 'yellow':
        return 50;
      default:
        return 15;
    }
  }

  String _formatCategory(String cat) {
    const labels = {
      'diabetes1': 'Type 1 Diabetes',
      'diabetes2': 'Type 2 Diabetes',
      'heart': 'Heart Disease',
      'hypertension': 'Hypertension',
      'pregnancy': 'Pregnancy',
      'anxiety': 'Anxiety',
      'asthma': 'Asthma',
      'epilepsy': 'Epilepsy',
      'autism': 'Autism',
      'adhd': 'ADHD',
      'dyslexia': 'Dyslexia',
      'deafMute': 'Deaf-Mute',
      'disability': 'Disability',
      'surgery': 'Post-Surgery',
      'elderly': 'Elderly Care',
      'general': 'General',
    };
    return labels[cat] ?? cat;
  }
}
