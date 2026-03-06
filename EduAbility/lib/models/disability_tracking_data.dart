// Data models for disability-specific tracking.
// Stored locally via SharedPreferences as JSON.

// ── Autism: Sensory/Meltdown Events ──
class SensoryEvent {
  final DateTime timestamp;
  final int severity; // 1=mild, 2=moderate, 3=severe
  final String trigger; // noise, light, touch, change, unknown

  SensoryEvent({
    required this.timestamp,
    required this.severity,
    this.trigger = 'unknown',
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'severity': severity,
    'trigger': trigger,
  };

  factory SensoryEvent.fromJson(Map<String, dynamic> json) => SensoryEvent(
    timestamp: DateTime.parse(json['timestamp']),
    severity: json['severity'] ?? 1,
    trigger: json['trigger'] ?? 'unknown',
  );
}

// ── Autism: Daily Routine Items ──
class RoutineItem {
  final String name;
  final bool completed;
  final DateTime date;

  RoutineItem({required this.name, required this.completed, required this.date});

  RoutineItem copyWith({bool? completed}) => RoutineItem(
    name: name,
    completed: completed ?? this.completed,
    date: date,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'completed': completed,
    'date': date.toIso8601String(),
  };

  factory RoutineItem.fromJson(Map<String, dynamic> json) => RoutineItem(
    name: json['name'],
    completed: json['completed'] ?? false,
    date: DateTime.parse(json['date']),
  );

  static const List<String> defaultItems = [
    'Morning Routine',
    'Meals On Time',
    'Study Session',
    'Exercise',
    'Bedtime Routine',
  ];
}

// ── ADHD: Focus Sessions ──
class FocusSession {
  final DateTime startTime;
  final int durationMinutes;
  final int breakMinutes;
  final bool completed;

  FocusSession({
    required this.startTime,
    required this.durationMinutes,
    this.breakMinutes = 5,
    this.completed = true,
  });

  Map<String, dynamic> toJson() => {
    'startTime': startTime.toIso8601String(),
    'durationMinutes': durationMinutes,
    'breakMinutes': breakMinutes,
    'completed': completed,
  };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
    startTime: DateTime.parse(json['startTime']),
    durationMinutes: json['durationMinutes'] ?? 25,
    breakMinutes: json['breakMinutes'] ?? 5,
    completed: json['completed'] ?? true,
  );
}

// ── ADHD: Task Entries ──
class TaskEntry {
  final DateTime date;
  final int planned;
  final int completed;

  TaskEntry({required this.date, required this.planned, required this.completed});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'planned': planned,
    'completed': completed,
  };

  factory TaskEntry.fromJson(Map<String, dynamic> json) => TaskEntry(
    date: DateTime.parse(json['date']),
    planned: json['planned'] ?? 0,
    completed: json['completed'] ?? 0,
  );
}

// ── Dyslexia: Reading Sessions ──
class ReadingSession {
  final DateTime date;
  final int durationMinutes;
  final int comprehensionRating; // 1-5
  final int wordsPerMinute;

  ReadingSession({
    required this.date,
    required this.durationMinutes,
    this.comprehensionRating = 3,
    this.wordsPerMinute = 0,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'durationMinutes': durationMinutes,
    'comprehensionRating': comprehensionRating,
    'wordsPerMinute': wordsPerMinute,
  };

  factory ReadingSession.fromJson(Map<String, dynamic> json) => ReadingSession(
    date: DateTime.parse(json['date']),
    durationMinutes: json['durationMinutes'] ?? 0,
    comprehensionRating: json['comprehensionRating'] ?? 3,
    wordsPerMinute: json['wordsPerMinute'] ?? 0,
  );
}

// ── Deaf-Mute: Communication Logs ──
class CommunicationLog {
  final DateTime timestamp;
  final String method; // sign_language, text, lip_reading, gesture
  final int durationMinutes;

  CommunicationLog({
    required this.timestamp,
    required this.method,
    required this.durationMinutes,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'method': method,
    'durationMinutes': durationMinutes,
  };

  factory CommunicationLog.fromJson(Map<String, dynamic> json) => CommunicationLog(
    timestamp: DateTime.parse(json['timestamp']),
    method: json['method'] ?? 'text',
    durationMinutes: json['durationMinutes'] ?? 0,
  );

  static const List<String> methods = ['sign_language', 'text', 'lip_reading', 'gesture'];
  static const Map<String, String> methodLabels = {
    'sign_language': 'Sign Language',
    'text': 'Text',
    'lip_reading': 'Lip Reading',
    'gesture': 'Gesture',
  };
}

// ── Deaf-Mute: Sign Practice ──
class SignPracticeEntry {
  final DateTime date;
  final int practiceMinutes;
  final int goalMinutes;

  SignPracticeEntry({
    required this.date,
    required this.practiceMinutes,
    this.goalMinutes = 30,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'practiceMinutes': practiceMinutes,
    'goalMinutes': goalMinutes,
  };

  factory SignPracticeEntry.fromJson(Map<String, dynamic> json) => SignPracticeEntry(
    date: DateTime.parse(json['date']),
    practiceMinutes: json['practiceMinutes'] ?? 0,
    goalMinutes: json['goalMinutes'] ?? 30,
  );
}
