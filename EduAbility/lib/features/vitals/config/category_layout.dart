import 'package:mobile/services/api_service.dart';
import 'package:mobile/services/disability_provider.dart';

enum DashboardSection {
  riskGauge,
  summaryCards,
  heartRateChart,
  bloodPressureChart,
  glucoseChart,
  activityRings,
  sleepChart,
  menstrualCycleCard,
  healthTips,
  // Disability-specific
  sensoryEventChart,
  routineAdherenceChart,
  focusSessionChart,
  taskCompletionChart,
  readingSessionChart,
  wordFluencyChart,
  communicationLogChart,
  signPracticeChart,
}

class CategoryLayout {
  static final Map<String, List<DashboardSection>> _categoryMap = {
    'diabetes1': [
      DashboardSection.glucoseChart,
      DashboardSection.riskGauge,
      DashboardSection.summaryCards,
      DashboardSection.heartRateChart,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
    'diabetes2': [
      DashboardSection.glucoseChart,
      DashboardSection.riskGauge,
      DashboardSection.summaryCards,
      DashboardSection.heartRateChart,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
    'heart': [
      DashboardSection.heartRateChart,
      DashboardSection.bloodPressureChart,
      DashboardSection.riskGauge,
      DashboardSection.summaryCards,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
    'hypertension': [
      DashboardSection.bloodPressureChart,
      DashboardSection.riskGauge,
      DashboardSection.summaryCards,
      DashboardSection.heartRateChart,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
    'pregnancy': [
      DashboardSection.menstrualCycleCard,
      DashboardSection.heartRateChart,
      DashboardSection.summaryCards,
      DashboardSection.sleepChart,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
    'anxiety': [
      DashboardSection.heartRateChart,
      DashboardSection.sleepChart,
      DashboardSection.riskGauge,
      DashboardSection.summaryCards,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
    'asthma': [
      DashboardSection.heartRateChart,
      DashboardSection.activityRings,
      DashboardSection.riskGauge,
      DashboardSection.summaryCards,
      DashboardSection.healthTips,
    ],
    'general': [
      DashboardSection.summaryCards,
      DashboardSection.riskGauge,
      DashboardSection.activityRings,
      DashboardSection.heartRateChart,
      DashboardSection.bloodPressureChart,
      DashboardSection.glucoseChart,
      DashboardSection.sleepChart,
      DashboardSection.healthTips,
    ],
    // Disability-specific layouts
    'autism': [
      DashboardSection.sensoryEventChart,
      DashboardSection.routineAdherenceChart,
      DashboardSection.heartRateChart,
      DashboardSection.sleepChart,
      DashboardSection.summaryCards,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
    'adhd': [
      DashboardSection.focusSessionChart,
      DashboardSection.taskCompletionChart,
      DashboardSection.activityRings,
      DashboardSection.sleepChart,
      DashboardSection.summaryCards,
      DashboardSection.healthTips,
    ],
    'dyslexia': [
      DashboardSection.readingSessionChart,
      DashboardSection.wordFluencyChart,
      DashboardSection.summaryCards,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
    'deafMute': [
      DashboardSection.communicationLogChart,
      DashboardSection.signPracticeChart,
      DashboardSection.summaryCards,
      DashboardSection.heartRateChart,
      DashboardSection.activityRings,
      DashboardSection.healthTips,
    ],
  };

  // Default for epilepsy, autism, disability, elderly, surgery
  static final List<DashboardSection> _defaultLayout = [
    DashboardSection.riskGauge,
    DashboardSection.summaryCards,
    DashboardSection.heartRateChart,
    DashboardSection.bloodPressureChart,
    DashboardSection.activityRings,
    DashboardSection.healthTips,
  ];

  static List<DashboardSection> getSectionsForUser({DisabilityType? disability}) {
    final categories = [...ApiService.healthCategories];
    final gender = ApiService.currentGender;

    // Bridge DisabilityProvider into category system
    if (disability != null && disability != DisabilityType.none) {
      final disabilityCategory = {
        DisabilityType.autistic: 'autism',
        DisabilityType.adhd: 'adhd',
        DisabilityType.dyslexia: 'dyslexia',
        DisabilityType.deafMute: 'deafMute',
      }[disability];
      if (disabilityCategory != null && !categories.contains(disabilityCategory)) {
        categories.insert(0, disabilityCategory);
      }
    }

    if (categories.isEmpty) {
      return _categoryMap['general']!;
    }

    // Union all sections from user's categories, preserving priority order
    final seen = <DashboardSection>{};
    final result = <DashboardSection>[];

    for (final cat in categories) {
      final sections = _categoryMap[cat] ?? _defaultLayout;
      for (final section in sections) {
        if (seen.add(section)) {
          result.add(section);
        }
      }
    }

    // Remove menstrual cycle if not female
    if (gender?.toLowerCase() != 'female') {
      result.remove(DashboardSection.menstrualCycleCard);
    }

    return result;
  }
}
