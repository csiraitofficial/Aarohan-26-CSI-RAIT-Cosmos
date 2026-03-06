class HealthTipsData {
  static const Map<String, List<String>> tips = {
    'diabetes1': [
      'Monitor blood glucose before and after meals',
      'Keep fast-acting glucose tabs for hypoglycemia emergencies',
      'Regular foot checks help prevent diabetic complications',
    ],
    'diabetes2': [
      'A 30-minute daily walk helps regulate blood sugar',
      'Choose complex carbs over simple sugars',
      'Stay hydrated — dehydration can spike glucose levels',
    ],
    'heart': [
      'Keep resting heart rate below 80 bpm when possible',
      'Omega-3 fatty acids support cardiovascular health',
      'Report any chest pain or irregular heartbeat immediately',
    ],
    'hypertension': [
      'Reduce sodium intake to less than 2300 mg/day',
      'Regular deep breathing exercises can lower BP',
      'Avoid sudden posture changes to prevent dizziness',
    ],
    'pregnancy': [
      'Stay hydrated — drink at least 8-10 glasses of water daily',
      'Monitor fetal movements daily after 28 weeks',
      'Take prenatal vitamins with folic acid',
    ],
    'anxiety': [
      'Practice box breathing: 4s inhale, 4s hold, 4s exhale, 4s hold',
      'High heart rate may indicate a stress episode',
      'Regular sleep schedule reduces anxiety symptoms',
    ],
    'asthma': [
      'Keep rescue inhaler accessible at all times',
      'Monitor heart rate during exercise — stop if above 150 bpm',
      'Avoid outdoor activity when air quality is poor',
    ],
    'epilepsy': [
      'Maintain a consistent sleep schedule',
      'Stay hydrated and avoid alcohol',
      'Keep a seizure diary to track triggers',
    ],
    'autism': [
      'Predictable routines help reduce sensory overload',
      'Monitor heart rate for signs of stress or meltdown',
      'Regular physical activity improves mood and focus',
    ],
    'adhd': [
      'Break tasks into smaller chunks with timed focus sessions',
      'Use the Pomodoro technique: 25 min focus, 5 min break',
      'Physical exercise before studying boosts concentration',
    ],
    'dyslexia': [
      'Use text-to-speech tools to reduce reading fatigue',
      'Short daily reading practice improves fluency over time',
      'Colored overlays can reduce visual stress while reading',
    ],
    'deafMute': [
      'Daily sign language practice builds communication confidence',
      'Try different communication methods to find what works best',
      'Video calls with subtitles can supplement lip reading',
    ],
    'disability': [
      'Adaptive exercises can improve cardiovascular health',
      'Monitor vitals regularly to catch changes early',
      'Stay connected with your care team',
    ],
    'surgery': [
      'Follow post-operative activity restrictions closely',
      'Watch for signs of infection: fever, elevated heart rate',
      'Gradual return to activity as cleared by your doctor',
    ],
    'elderly': [
      'Fall prevention: ensure good lighting and remove trip hazards',
      'Blood pressure can drop when standing — rise slowly',
      'Daily walks help maintain bone density and balance',
    ],
    'general': [
      'Aim for 7-9 hours of quality sleep each night',
      'Drink water throughout the day, not just when thirsty',
      'Take movement breaks every 60 minutes of sitting',
    ],
  };

  static const Map<String, List<String>> alertTips = {
    'high_hr': [
      'Your heart rate is elevated. Sit down and breathe slowly.',
      'If high heart rate persists, contact your doctor.',
    ],
    'low_hr': [
      'Your heart rate is below normal. Avoid sudden movements.',
      'Persistent low heart rate may need medical attention.',
    ],
    'high_bp': [
      'Blood pressure is high. Avoid caffeine and rest.',
      'Persistent high BP — consult your healthcare provider.',
    ],
    'high_glucose': [
      'Blood glucose is elevated. Check insulin and hydrate.',
      'Avoid sugary foods until levels normalize.',
    ],
    'low_glucose': [
      'Blood glucose is low. Eat fast-acting carbs now.',
      'Keep glucose tabs nearby for emergencies.',
    ],
  };

  static List<String> getTipsForUser(List<String> categories) {
    final result = <String>[];
    for (final cat in categories) {
      result.addAll(tips[cat] ?? []);
    }
    if (result.isEmpty) {
      result.addAll(tips['general']!);
    }
    return result;
  }
}
