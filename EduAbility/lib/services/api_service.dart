import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/models/user_vitals.dart';
import 'package:mobile/models/risk_result.dart';

class ApiService {
  /// Well-known candidates — probed **in parallel** for fast resolution.
  /// Covers: WiFi router subnet, PC mobile-hotspot, loopback, emulator.
  static const List<String> _staticCandidates = [
    'http://192.168.5.101:3000', // PC WiFi IP (current router subnet)
    'http://192.168.137.1:3000', // PC mobile-hotspot IP (always fixed)
    'http://192.168.1.1:3000', // Common home-router gateway
    'http://192.168.0.1:3000', // Common home-router gateway (alt)
    'http://localhost:3000', // Same PC (desktop / web / Windows app)
    'http://127.0.0.1:3000', // Same PC (explicit IPv4 loopback)
    'http://10.0.2.2:3000', // Android emulator loopback
  ];

  /// Final fallback when nothing on the LAN works.
  static const String _tunnelUrl = 'https://tknz9w00-3000.inc1.devtunnels.ms';

  static const int _port = 3000;

  /// Active backend URL — resolved once by [resolveBackend].
  static String baseUrl = _tunnelUrl;

  /// Whether a successful resolution has happened at least once.
  static bool _resolved = false;

  /// Call once at app startup.
  ///
  /// 1. Probes all static IPs **in parallel** (≈2 s max).
  /// 2. Auto-scans the device's current subnet for port 3000.
  /// 3. Falls back to the dev-tunnel URL.
  static Future<void> resolveBackend() async {
    // ── Phase 1: static candidates (all in parallel, first wins) ──
    final staticResult = await _raceProbes(_staticCandidates, timeout: 3);
    if (staticResult != null) {
      baseUrl = staticResult;
      _resolved = true;
      print('[ApiService] Backend resolved (static) → $staticResult');
      return;
    }

    // ── Phase 2: subnet scan — try every .1–.254 in parallel ──
    final discovered = await _scanSubnets();
    if (discovered != null) {
      baseUrl = discovered;
      _resolved = true;
      print('[ApiService] Backend resolved (subnet scan) → $discovered');
      return;
    }

    // ── Phase 3: dev tunnel fallback ──
    if (await _isReachable(_tunnelUrl)) {
      baseUrl = _tunnelUrl;
      _resolved = true;
      print('[ApiService] Backend resolved (tunnel) → $_tunnelUrl');
      return;
    }

    print('[ApiService] ⚠ No backend found, keeping default: $baseUrl');
  }

  /// Re-run discovery. Useful when the app detects the backend is unreachable
  /// (e.g. phone switched WiFi networks). Tries the currently cached URL
  /// first for speed before falling back to full discovery.
  static Future<void> reResolveBackend() async {
    // Quick check: is the current URL still alive?
    if (await _isReachable(baseUrl)) {
      print('[ApiService] Re-resolve: current URL still alive → $baseUrl');
      return;
    }
    print('[ApiService] Re-resolve: current URL unreachable, rediscovering…');
    await resolveBackend();
  }

  /// Try to reach [url] with a short timeout.
  static Future<bool> _isReachable(String url) async {
    try {
      final response = await http
          .get(Uri.parse('$url/'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Race a list of URL candidates in parallel.
  /// Returns the first URL that responds 200, or null if none do within [timeout].
  static Future<String?> _raceProbes(
    List<String> urls, {
    int timeout = 3,
  }) async {
    if (urls.isEmpty) return null;
    try {
      return await Future.any(
        urls.map((url) => _probe(url)),
      ).timeout(Duration(seconds: timeout), onTimeout: () => null);
    } catch (_) {
      return null;
    }
  }

  /// Discover the backend by scanning every IPv4 subnet the device is on.
  /// Sends requests to .1–.254 in parallel with a tight timeout.
  static Future<String?> _scanSubnets() async {
    try {
      final subnets = <String>{};
      for (final iface in await NetworkInterface.list()) {
        for (final addr in iface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            final parts = addr.address.split('.');
            subnets.add('${parts[0]}.${parts[1]}.${parts[2]}');
          }
        }
      }
      if (subnets.isEmpty) return null;

      // Fire all 254 × N requests in parallel; first 200-OK wins.
      final urls = <String>[];
      for (final subnet in subnets) {
        for (int i = 1; i <= 254; i++) {
          urls.add('http://$subnet.$i:$_port');
        }
      }

      return await _raceProbes(urls, timeout: 4);
    } catch (e) {
      print('[ApiService] Subnet scan error: $e');
      return null;
    }
  }

  /// Returns [url] if it responds 200, or hangs forever (cancelled by
  /// [Future.any] once another probe wins).
  static Future<String?> _probe(String url) async {
    try {
      final response = await http
          .get(Uri.parse('$url/'))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) return url;
    } catch (_) {}
    // Never complete so Future.any ignores losers.
    return Future.delayed(const Duration(days: 1), () => null);
  }

  // Doctor session info
  static String? currentDoctorId;
  static String? currentDoctorName;
  static String? currentUserId; // Keep track of the logged-in user
  static String? currentStudentName; // Display name of logged-in student
  static const String defaultUserId = '1';

  // Health profile — set during signup, persists for the session
  static String? currentGender; // 'Male', 'Female', 'Other'
  static List<String> healthCategories = [];
  static String emergencyContact =
      '+917744039115'; // phone number for spike SMS alerts
  // Menstrual cycle (populated when gender is Female)
  static DateTime? lastPeriodDate;
  static int menstrualCycleLength = 28; // days
  static int menstrualPeriodDuration = 5; // days

  /// Check if backend is reachable. Auto-rediscovers if the current URL is
  /// unreachable (handles WiFi network switches).
  Future<bool> checkConnection() async {
    try {
      final uri = Uri.parse(baseUrl);
      await http.get(uri).timeout(const Duration(seconds: 3));
      return true;
    } catch (e) {
      // Current URL failed — try rediscovering the backend
      if (_resolved) {
        print('[ApiService] Connection lost, re-resolving backend…');
        await reResolveBackend();
        // Check the newly resolved URL
        try {
          final uri = Uri.parse(baseUrl);
          await http.get(uri).timeout(const Duration(seconds: 3));
          return true;
        } catch (_) {
          return false;
        }
      }
      return false;
    }
  }

  /// Sync vitals to the backend. Returns true on success.
  Future<bool> syncVitals(UserVitals vitals, {String? userId}) async {
    final effectiveUserId = userId ?? currentUserId ?? defaultUserId;
    try {
      int systolic = 0;
      int diastolic = 0;
      if (vitals.bloodPressures.isNotEmpty) {
        systolic = vitals.bloodPressures.first.systolic;
        diastolic = vitals.bloodPressures.first.diastolic;
      }

      int hr = vitals.heartRates.isNotEmpty ? vitals.heartRates.first.value : 0;
      double glu = vitals.bloodGlucose.isNotEmpty
          ? vitals.bloodGlucose.first.value
          : 0.0;
      int steps = vitals.todaySteps;
      int cal = vitals.todayCalories.toInt();
      int act = vitals.todayActiveMinutes;

      final queryParams = {
        'patient_id': effectiveUserId,
        'heart_rate': hr.toString(),
        'bp': '$systolic/$diastolic',
        'steps': steps.toString(),
        'calories': cal.toString(),
        'active_min': act.toString(),
        'glucose': glu.toString(),
      };

      final uri = Uri.parse(
        '$baseUrl/patient/set_vitals',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri);

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // Don't crash the UI if backend is unreachable
      return false;
    }
  }

  /// Evaluate health risk from current vitals. Returns null if backend unreachable.
  Future<RiskResult?> syncAndEvaluateRisk(
    UserVitals vitals, {
    String? userId,
  }) async {
    final effectiveUserId = userId ?? currentUserId ?? defaultUserId;
    // Note: The new Node.js backend does not currently have the Python AI/Risk models.
    // For now, we mock the risk evaluation locally to keep the app functional
    // and prevent crashing.

    int systolic = 0;
    int hr = vitals.heartRates.isNotEmpty ? vitals.heartRates.first.value : 0;
    double glu = vitals.bloodGlucose.isNotEmpty
        ? vitals.bloodGlucose.first.value
        : 0.0;

    if (vitals.bloodPressures.isNotEmpty) {
      systolic = vitals.bloodPressures.first.systolic;
    }

    String zone = "Green";

    if (systolic > 140 || hr > 100 || glu > 140.0) {
      zone = "Yellow";
    }
    if (systolic > 180 || hr > 120 || glu > 200.0) {
      zone = "Red";
    }

    // Sync vitals to the new Node.js backend as part of this process
    await syncVitals(vitals, userId: effectiveUserId);

    return RiskResult(
      userId: effectiveUserId,
      riskZone: zone.toLowerCase(),
      riskScore: zone == "Red" ? 80.0 : (zone == "Yellow" ? 50.0 : 10.0),
      keyFactors: ["Local Mock Evaluation", "Blood Pressure: $systolic"],
      recommendedAction: "Consult a doctor if vitals remain high.",
    );
  }

  /// Log in to the backend
  Future<bool> login(String username, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/patient/login');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: '{"username": "$username", "password": "$password"}',
      );
      if (response.statusCode == 200) {
        final String bodyStr = response.body;
        if (bodyStr.contains('"success":true')) {
          final RegExp regExp = RegExp(r'"patient_id":(\d+)');
          final match = regExp.firstMatch(bodyStr);
          if (match != null) {
            currentUserId = match.group(1);
          } else {
            currentUserId = defaultUserId;
          }
          final RegExp nameRegExp = RegExp(r'"name":"([^"]+)"');
          final nameMatch = nameRegExp.firstMatch(bodyStr);
          currentStudentName = nameMatch?.group(1) ?? username;
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /// Sign up a new user
  Future<bool> signUp(String username, String password, String name) async {
    try {
      final uri = Uri.parse('$baseUrl/patient/signup');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body:
            '{"username": "$username", "password": "$password", "name": "$name"}',
      );
      if (response.statusCode == 200) {
        final String bodyStr = response.body;
        if (bodyStr.contains('"success":true')) {
          final RegExp regExp = RegExp(r'"patient_id":(\d+)');
          final match = regExp.firstMatch(bodyStr);
          if (match != null) {
            currentUserId = match.group(1);
          } else {
            currentUserId = defaultUserId;
          }
          currentStudentName = name;
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  /// Report a heart rate spike to the backend for logging and Twilio integration
  Future<void> reportSpike(
    String patientId,
    int heartRate,
    double lat,
    double lng,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/patient/alert_spike');
      await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body:
            '{"patient_id": "$patientId", "heart_rate": $heartRate, "lat": $lat, "lng": $lng}',
      );
    } catch (_) {}
  }

  // DOCTOR APIS
  /// Doctor login
  Future<bool> loginDoctor(String mobile, String pin) async {
    try {
      final uri = Uri.parse('$baseUrl/doctor/login?mobile=$mobile&pin=$pin');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final String bodyStr = response.body;
        if (bodyStr.contains('"success":true')) {
          final RegExp regExp = RegExp(r'"doctor_id":(\d+)');
          final match = regExp.firstMatch(bodyStr);
          if (match != null) {
            currentDoctorId = match.group(1);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Doctor login error: $e');
      return false;
    }
  }

  /// Doctor signup/register
  Future<bool> registerDoctor({
    required String pin,
    required String mobile,
    required String name,
    required String degree,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/doctor/register?pin=$pin&mobile=$mobile&name=$name&degree=$degree',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final String bodyStr = response.body;
        if (bodyStr.contains('"success":true')) {
          // Doctor ID is not returned, but registration succeeded
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Doctor register error: $e');
      return false;
    }
  }

  /// Get doctor profile info
  Future<Map<String, dynamic>?> getDoctorInfo(String doctorId) async {
    try {
      final uri = Uri.parse('$baseUrl/doctor/get_info?doctor_id=$doctorId');
      final response = await http.get(uri);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Get doctor info error: $e');
      return null;
    }
  }

  /// Get doctor appointments
  Future<List<dynamic>?> getDoctorAppointments(String doctorId) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/doctor/get_appointments?doctor_id=$doctorId',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return List<dynamic>.from(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Get doctor appointments error: $e');
      return null;
    }
  }

  /// Confirm appointment
  Future<bool> confirmAppointment(String appointmentId) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/doctor/confirm_appointment?appointment_id=$appointmentId',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final String bodyStr = response.body;
        return bodyStr.contains('"success":true');
      }
      return false;
    } catch (e) {
      print('Confirm appointment error: $e');
      return false;
    }
  }

  /// Get doctor patients
  Future<List<dynamic>?> getDoctorPatients(String doctorId) async {
    try {
      final uri = Uri.parse('$baseUrl/doctor/get_patients?doctor_id=$doctorId');
      final response = await http.get(uri);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return List<dynamic>.from(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Get doctor patients error: $e');
      return null;
    }
  }

  /// Get patient vitals (for doctor)
  Future<Map<String, dynamic>?> getPatientVitals(String patientId) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/patient/get_vitals?patient_id=$patientId',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is List && decoded.isNotEmpty) {
          // If backend returns a list, use the first item
          return Map<String, dynamic>.from(decoded.first);
        } else if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Get patient vitals error: $e');
      return null;
    }
  }
}
