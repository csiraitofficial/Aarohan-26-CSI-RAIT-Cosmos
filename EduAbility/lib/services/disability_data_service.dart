import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_provider.dart';

class DisabilityDataService {
  // ── Keys ──
  static const _sensoryKey = 'disability_sensory_events';
  static const _routineKey = 'disability_routine_items';
  static const _focusKey = 'disability_focus_sessions';
  static const _taskKey = 'disability_task_entries';
  static const _readingKey = 'disability_reading_sessions';
  static const _commKey = 'disability_comm_logs';
  static const _signKey = 'disability_sign_practice';

  // ── Generic helpers ──
  static Future<List<Map<String, dynamic>>> _loadList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(raw));
  }

  static Future<void> _saveList(String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  // ── Sensory Events (Autism) ──
  static Future<List<SensoryEvent>> loadSensoryEvents() async {
    final list = await _loadList(_sensoryKey);
    return list.map((e) => SensoryEvent.fromJson(e)).toList();
  }

  static Future<void> saveSensoryEvents(List<SensoryEvent> events) async {
    await _saveList(_sensoryKey, events.map((e) => e.toJson()).toList());
  }

  // ── Routine Items (Autism) ──
  static Future<List<RoutineItem>> loadRoutineItems() async {
    final list = await _loadList(_routineKey);
    return list.map((e) => RoutineItem.fromJson(e)).toList();
  }

  static Future<void> saveRoutineItems(List<RoutineItem> items) async {
    await _saveList(_routineKey, items.map((e) => e.toJson()).toList());
  }

  // ── Focus Sessions (ADHD) ──
  static Future<List<FocusSession>> loadFocusSessions() async {
    final list = await _loadList(_focusKey);
    return list.map((e) => FocusSession.fromJson(e)).toList();
  }

  static Future<void> saveFocusSessions(List<FocusSession> sessions) async {
    await _saveList(_focusKey, sessions.map((e) => e.toJson()).toList());
  }

  // ── Task Entries (ADHD) ──
  static Future<List<TaskEntry>> loadTaskEntries() async {
    final list = await _loadList(_taskKey);
    return list.map((e) => TaskEntry.fromJson(e)).toList();
  }

  static Future<void> saveTaskEntries(List<TaskEntry> entries) async {
    await _saveList(_taskKey, entries.map((e) => e.toJson()).toList());
  }

  // ── Reading Sessions (Dyslexia) ──
  static Future<List<ReadingSession>> loadReadingSessions() async {
    final list = await _loadList(_readingKey);
    return list.map((e) => ReadingSession.fromJson(e)).toList();
  }

  static Future<void> saveReadingSessions(List<ReadingSession> sessions) async {
    await _saveList(_readingKey, sessions.map((e) => e.toJson()).toList());
  }

  // ── Communication Logs (Deaf-Mute) ──
  static Future<List<CommunicationLog>> loadCommunicationLogs() async {
    final list = await _loadList(_commKey);
    return list.map((e) => CommunicationLog.fromJson(e)).toList();
  }

  static Future<void> saveCommunicationLogs(List<CommunicationLog> logs) async {
    await _saveList(_commKey, logs.map((e) => e.toJson()).toList());
  }

  // ── Sign Practice (Deaf-Mute) ──
  static Future<List<SignPracticeEntry>> loadSignPractice() async {
    final list = await _loadList(_signKey);
    return list.map((e) => SignPracticeEntry.fromJson(e)).toList();
  }

  static Future<void> saveSignPractice(List<SignPracticeEntry> entries) async {
    await _saveList(_signKey, entries.map((e) => e.toJson()).toList());
  }

  // ── Mock Data Generation ──
  static Future<void> generateMockData(DisabilityType type) async {
    final now = DateTime.now();
    final seed = now.millisecondsSinceEpoch;

    switch (type) {
      case DisabilityType.autistic:
        // 7 days of sensory events
        final events = <SensoryEvent>[];
        final triggers = ['noise', 'light', 'touch', 'change', 'unknown'];
        for (int d = 6; d >= 0; d--) {
          final count = 1 + (seed + d * 13) % 4; // 1-4 events per day
          for (int e = 0; e < count; e++) {
            events.add(SensoryEvent(
              timestamp: now.subtract(Duration(days: d, hours: 8 + e * 3)),
              severity: 1 + (seed + d * 7 + e * 11) % 3,
              trigger: triggers[(seed + d + e) % triggers.length],
            ));
          }
        }
        await saveSensoryEvents(events);

        // 7 days of routine items
        final routines = <RoutineItem>[];
        for (int d = 6; d >= 0; d--) {
          final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: d));
          for (int i = 0; i < RoutineItem.defaultItems.length; i++) {
            routines.add(RoutineItem(
              name: RoutineItem.defaultItems[i],
              completed: (seed + d * 3 + i * 7) % 10 > 3, // ~60-70% completion
              date: date,
            ));
          }
        }
        await saveRoutineItems(routines);
        break;

      case DisabilityType.adhd:
        // 7 days of focus sessions
        final sessions = <FocusSession>[];
        for (int d = 6; d >= 0; d--) {
          final count = 1 + (seed + d * 17) % 4; // 1-4 sessions per day
          for (int s = 0; s < count; s++) {
            sessions.add(FocusSession(
              startTime: now.subtract(Duration(days: d, hours: 9 + s * 2)),
              durationMinutes: 15 + (seed + d * 5 + s * 13) % 35, // 15-50 min
              breakMinutes: 5 + (seed + d + s) % 10, // 5-15 min
              completed: (seed + d + s) % 5 != 0, // ~80% completed
            ));
          }
        }
        await saveFocusSessions(sessions);

        // 7 days of task entries
        final tasks = <TaskEntry>[];
        for (int d = 6; d >= 0; d--) {
          final planned = 3 + (seed + d * 11) % 6; // 3-8 tasks
          final completed = (planned * (50 + (seed + d * 7) % 50) / 100).round().clamp(0, planned);
          tasks.add(TaskEntry(
            date: now.subtract(Duration(days: d)),
            planned: planned,
            completed: completed,
          ));
        }
        await saveTaskEntries(tasks);
        break;

      case DisabilityType.dyslexia:
        // 7 days of reading sessions
        final sessions = <ReadingSession>[];
        for (int d = 6; d >= 0; d--) {
          sessions.add(ReadingSession(
            date: now.subtract(Duration(days: d)),
            durationMinutes: 10 + (seed + d * 19) % 35, // 10-45 min
            comprehensionRating: 2 + (seed + d * 7) % 4, // 2-5
            wordsPerMinute: 80 + (d * 5) + (seed + d) % 20, // trending up
          ));
        }
        await saveReadingSessions(sessions);
        break;

      case DisabilityType.deafMute:
        // 7 days of communication logs
        final logs = <CommunicationLog>[];
        for (int d = 6; d >= 0; d--) {
          for (final method in CommunicationLog.methods) {
            final mins = 5 + (seed + d * 7 + method.hashCode) % 50;
            logs.add(CommunicationLog(
              timestamp: now.subtract(Duration(days: d, hours: 10)),
              method: method,
              durationMinutes: mins,
            ));
          }
        }
        await saveCommunicationLogs(logs);

        // 7 days of sign practice
        final practice = <SignPracticeEntry>[];
        for (int d = 6; d >= 0; d--) {
          practice.add(SignPracticeEntry(
            date: now.subtract(Duration(days: d)),
            practiceMinutes: 10 + (seed + d * 23) % 30, // 10-40 min
            goalMinutes: 30,
          ));
        }
        await saveSignPractice(practice);
        break;

      case DisabilityType.none:
        break;
    }
  }
}
