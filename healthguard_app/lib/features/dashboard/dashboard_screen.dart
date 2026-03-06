import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:vibration/vibration.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../../core/constants/app_constants.dart';
import '../vitals/vitals_screen.dart';

import '../profile/profile_screen.dart';
import '../sign_language/sign_language_screen.dart';
import '../offline_ai/offline_ai_screen.dart';

import '../../services/health_service.dart';
import '../../services/spike_alert_service.dart';
import '../../services/api_service.dart';
import '../../models/user_vitals.dart';
import '../../models/vital_reading.dart';
import '../../models/blood_pressure_reading.dart';
import '../../models/risk_result.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final HealthService _healthService = HealthService();
  final ApiService _apiService = ApiService();
  UserVitals? _vitals;
  RiskResult? _riskResult;
  bool _isLoading = false;
  bool _isBackendConnected = false;
  bool _isCheckingConnection = true;

  // Emergency contact comes from signup; doctor contact is future work
  String get _emergencyContact => ApiService.emergencyContact;
  final String _doctorContact = ''; // doctor's mobile (future)
  bool _spikeDialogShown = false;

  /// Manual override — toggleable from the app-bar icon.
  bool _specialNeedsOverride = false;

  /// True when signup categories include a special-needs condition,
  /// OR the user has manually enabled the override via the app-bar icon.
  bool get _isSpecialNeeds {
    if (_specialNeedsOverride) return true;
    final cats = ApiService.healthCategories;
    return cats.contains('autism') ||
        cats.contains('epilepsy') ||
        cats.contains('elderly') ||
        cats.contains('disability');
  }

  String _getGreeting(AppLocalizations l) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return l.goodMorning;
    } else if (hour < 17) {
      return l.goodAfternoon;
    } else {
      return l.goodEvening;
    }
  }

  String get _studentName =>
      ApiService.currentStudentName ??
      AppLocalizations.of(context)?.student ??
      'Student';

  String _studentGreeting(AppLocalizations l) {
    final greeting = _getGreeting(l);
    return '$greeting, $_studentName';
  }

  @override
  void initState() {
    super.initState();
    _fetchVitals();
    _checkBackendStatus();
  }

  Future<void> _checkBackendStatus() async {
    if (mounted) setState(() => _isCheckingConnection = true);
    final isConnected = await _apiService.checkConnection();
    if (mounted) {
      setState(() {
        _isBackendConnected = isConnected;
        _isCheckingConnection = false;
      });
    }
  }

  // ── Vibration ──────────────────────────────────────────────────────────────
  Future<void> _vibrateAlert() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        // Pattern: wait 0, buzz 800, pause 300, buzz 800, pause 300, buzz 800
        await Vibration.vibrate(pattern: [0, 800, 300, 800, 300, 800]);
      }
    } catch (_) {}
  }

  // ── Shared spike-alert logic (real + mock) ─────────────────────────────────
  void _runSpikeAlert(int hr, {bool isMock = false}) {
    if (_spikeDialogShown) return;
    setState(() => _spikeDialogShown = true);

    _vibrateAlert();

    SpikeAlertService.checkAndAlert(
      heartRate: hr,
      patientId: ApiService.currentUserId ?? '1',
      emergencyContact: _emergencyContact,
      doctorContact: _doctorContact,
      patientName: _studentName,
    );

    final l = AppLocalizations.of(context)!;
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.red.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isMock
              ? '🚨 ${l.testEmergencyAlertTitle}'
              : '🚨 ${l.heartRateSpikeDetected}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isMock ? l.mockHeartRateMsg(hr) : l.realSpikeMsg(hr),
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        actions: [
          TextButton(
            child: Text(
              l.dismiss,
              style: const TextStyle(color: Colors.yellowAccent, fontSize: 18),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // ── Vitals Simulator bottom sheet ──────────────────────────────────────────
  void _showVitalsSimulator() {
    int mockHr = 75;
    int mockSystolic = 120;
    int mockDiastolic = 80;
    double mockGlucose = 95.0;

    // Pre-fill from signup; user can override for this test run
    final contactCtrl = TextEditingController(
      text: ApiService.emergencyContact,
    );

    final l = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final hrAlert = mockHr > SpikeAlertService.spikeThreshold;
          final bpAlert = mockSystolic > 140;
          final glucAlert = mockGlucose > 140;
          final anyAlert = hrAlert || bpAlert || glucAlert;

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.science, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Text(
                        l.emergencyVitalsSimulator,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.slideValuesAbove,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Divider(height: 20),

                  // ── Emergency contact (editable override) ───────────────
                  TextField(
                    controller: contactCtrl,
                    decoration: InputDecoration(
                      labelText: l.emergencyContactNumber,
                      hintText: 'e.g. +919876543210',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.emergency,
                        color: Colors.red,
                      ),
                      helperText: ApiService.emergencyContact.isEmpty
                          ? l.noNumberSet
                          : l.fromProfileEditable,
                      helperStyle: TextStyle(
                        color: ApiService.emergencyContact.isEmpty
                            ? Colors.red.shade700
                            : Colors.grey[600],
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),

                  // ── Heart Rate ──────────────────────────────────────────
                  _simulatorSlider(
                    label: l.heartRate,
                    value: mockHr.toDouble(),
                    unit: 'BPM',
                    min: 40,
                    max: 200,
                    threshold: SpikeAlertService.spikeThreshold.toDouble(),
                    alert: hrAlert,
                    onChanged: (v) => setSheet(() => mockHr = v.round()),
                    l: l,
                  ),

                  // ── Systolic BP ─────────────────────────────────────────
                  _simulatorSlider(
                    label: l.systolicBp,
                    value: mockSystolic.toDouble(),
                    unit: 'mmHg',
                    min: 80,
                    max: 220,
                    threshold: 140,
                    alert: bpAlert,
                    onChanged: (v) => setSheet(() => mockSystolic = v.round()),
                    l: l,
                  ),

                  // ── Blood Glucose ───────────────────────────────────────
                  _simulatorSlider(
                    label: l.bloodGlucose,
                    value: mockGlucose,
                    unit: 'mg/dL',
                    min: 70,
                    max: 300,
                    threshold: 140,
                    alert: glucAlert,
                    onChanged: (v) => setSheet(() => mockGlucose = v),
                    l: l,
                  ),

                  const SizedBox(height: 8),

                  // ── Apply button ────────────────────────────────────────
                  OutlinedButton.icon(
                    icon: const Icon(Icons.dashboard_customize),
                    label: Text(l.applyMockVitals),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    onPressed: () {
                      final now = DateTime.now();
                      setState(() {
                        _vitals = UserVitals(
                          heartRates: [VitalReading<int>(now, mockHr)],
                          bloodPressures: [
                            BloodPressureReading(
                              timestamp: now,
                              systolic: mockSystolic,
                              diastolic: mockDiastolic,
                            ),
                          ],
                          bloodGlucose: [
                            VitalReading<double>(now, mockGlucose),
                          ],
                          sleepSessionsMinutes: [],
                          steps: [],
                          caloriesBurned: [],
                          activeMinutes: [],
                        );
                      });
                      Navigator.pop(ctx);
                    },
                  ),

                  const SizedBox(height: 8),

                  // ── Trigger alert button ────────────────────────────────
                  ElevatedButton.icon(
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: Text(
                      anyAlert
                          ? '🚨 ${l.triggerEmergencyAlert}'
                          : l.raiseValueAbove,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: anyAlert
                          ? Colors.red.shade700
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: anyAlert
                        ? () {
                            final now = DateTime.now();
                            setState(() {
                              _vitals = UserVitals(
                                heartRates: [VitalReading<int>(now, mockHr)],
                                bloodPressures: [
                                  BloodPressureReading(
                                    timestamp: now,
                                    systolic: mockSystolic,
                                    diastolic: mockDiastolic,
                                  ),
                                ],
                                bloodGlucose: [
                                  VitalReading<double>(now, mockGlucose),
                                ],
                                sleepSessionsMinutes: [],
                                steps: [],
                                caloriesBurned: [],
                                activeMinutes: [],
                              );
                            });
                            // Persist contact entered in simulator
                            final testContact = contactCtrl.text.trim();
                            if (testContact.isNotEmpty) {
                              ApiService.emergencyContact = testContact;
                            }
                            SpikeAlertService.resetSession();
                            setState(() => _spikeDialogShown = false);
                            Navigator.pop(ctx);
                            _runSpikeAlert(mockHr, isMock: true);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).then((_) => contactCtrl.dispose());
  }

  Widget _simulatorSlider({
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    required double threshold,
    required bool alert,
    required ValueChanged<double> onChanged,
    required AppLocalizations l,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: alert ? Colors.red.shade100 : Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: alert ? Colors.red.shade300 : Colors.teal.shade200,
                ),
              ),
              child: Text(
                '${value.round()} $unit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: alert ? Colors.red.shade800 : Colors.teal.shade800,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          activeColor: alert ? Colors.red : Colors.teal,
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            alert
                ? '⚠️ ${l.aboveThreshold(threshold.round().toString(), unit)}'
                : l.normalThreshold(threshold.round().toString(), unit),
            style: TextStyle(
              fontSize: 11,
              color: alert ? Colors.red.shade700 : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchVitals() async {
    setState(() => _isLoading = true);
    final now = DateTime.now();
    final vitals = await _healthService.fetchAllVitals(
      startTime: now.subtract(const Duration(days: 1)),
      endTime: now,
    );
    if (mounted) {
      setState(() {
        _vitals = vitals;
        _isLoading = false;
      });

      // Fire-and-forget: sync to backend + evaluate risk
      if (vitals != null) {
        _apiService.syncVitals(vitals);
        final risk = await _apiService.syncAndEvaluateRisk(vitals);
        if (mounted) setState(() => _riskResult = risk);

        // Emergency spike detection — delegates to shared _runSpikeAlert
        if (_isSpecialNeeds && mounted) {
          final hr = vitals.heartRates.isNotEmpty
              ? vitals.heartRates.first.value
              : 0;
          if (hr > SpikeAlertService.spikeThreshold) {
            _runSpikeAlert(hr);
          }
        }
      }
    }
  }

  List<Widget> get _screens => [
    _buildDashboardHome(),
    const VitalsScreen(),
    const SignLanguageScreen(),
    const OfflineAiScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitleForIndex(_currentIndex, l),
          style: TextStyle(fontSize: size.width < 360 ? 18 : 20),
        ),
        actions: [
          IconButton(
            icon: _isCheckingConnection
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    _isBackendConnected ? Icons.cloud_done : Icons.cloud_off,
                    color: _isBackendConnected ? Colors.green : Colors.red,
                  ),
            tooltip: _isBackendConnected
                ? l.backendConnected
                : l.backendDisconnected,
            onPressed: () {
              _checkBackendStatus();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBackendConnected
                        ? l.backendConnected
                        : l.backendDisconnected,
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.refreshVitals,
            onPressed: () {
              _fetchVitals();
              _checkBackendStatus();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.accessibility_new,
              color: _isSpecialNeeds ? Colors.amber : null,
            ),
            tooltip: _isSpecialNeeds
                ? l.specialNeedsModeOnTap
                : l.specialNeedsModeOffTap,
            onPressed: () {
              // Categories from signup auto-enable this; override allows manual toggle
              final cats = ApiService.healthCategories;
              final autoEnabled =
                  cats.contains('autism') ||
                  cats.contains('epilepsy') ||
                  cats.contains('elderly') ||
                  cats.contains('disability');
              setState(() => _specialNeedsOverride = !_specialNeedsOverride);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isSpecialNeeds
                        ? '🟡 ${l.specialNeedsOnAlerts}'
                              '${autoEnabled ? ' ${l.specialNeedsFromProfile}' : ' ${l.specialNeedsManual}'}'
                        : '⚪ ${l.specialNeedsModeOff}',
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l.notificationsNone)));
            },
          ),
        ],
      ),
      // drawer: _buildDrawer(context),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildDashboardHome() {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final l = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: _fetchVitals,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading) const LinearProgressIndicator(),
            Text(
              _studentGreeting(l),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 22 : 26,
              ),
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            Text(
              '${l.healthSnapshot} • ${DateTime.now().toString().substring(0, 10)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),

            // ── Emergency Alert Testing card ────────────────────────
            InkWell(
              onTap: _showVitalsSimulator,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(Icons.science, color: Colors.red.shade700, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.testEmergencyAlert,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.red.shade800,
                            ),
                          ),
                          Text(
                            l.simulateVitals,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.red.shade400),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Vitals grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.05, // responsive tall cards
              children: [
                _VitalCard(
                  title: l.heartRate,
                  value: _vitals?.latestHeartRate ?? 'N/A',
                  icon: Icons.favorite,
                  color: Colors.red,
                ),
                _VitalCard(
                  title: l.bp,
                  value: _vitals?.latestBloodPressure ?? 'N/A',
                  icon: Icons.speed,
                  color: Colors.blue,
                ),
                _VitalCard(
                  title: l.steps,
                  value: _vitals != null ? '${_vitals!.todaySteps}' : 'N/A',
                  icon: Icons.directions_walk,
                  color: Colors.teal,
                ),
                _VitalCard(
                  title: l.calories,
                  value: _vitals != null
                      ? _vitals!.todayCalories.toStringAsFixed(0)
                      : 'N/A',
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                ),
                _VitalCard(
                  title: l.activeMin,
                  value: _vitals != null
                      ? '${_vitals!.todayActiveMinutes}'
                      : 'N/A',
                  icon: Icons.timer,
                  color: Colors.green,
                ),
                _VitalCard(
                  title: l.glucose,
                  value: _vitals?.latestGlucose ?? 'N/A',
                  icon: Icons.bloodtype,
                  color: Colors.purple,
                ),
                _VitalCard(
                  title: l.spo2,
                  value: _vitals?.latestSpo2 ?? 'N/A',
                  icon: Icons.air,
                  color: Colors.cyan,
                ),
                _VitalCard(
                  title: l.stress,
                  value: _vitals?.latestStress ?? 'N/A',
                  icon: Icons.psychology,
                  color: Colors.amber,
                ),
              ],
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }

  String _getTitleForIndex(int index, AppLocalizations l) {
    switch (index) {
      case 0:
        return AppConstants.appName;
      case 1:
        return l.vitals;
      case 2:
        return l.signLanguage;
      case 3:
        return l.offlineAi;
      case 4:
        return l.profile;
      default:
        return AppConstants.appName;
    }
  }
}

// VitalCard (responsive)
class _VitalCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _VitalCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isSmallScreen ? 32 : 36, color: color),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            FittedBox(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
