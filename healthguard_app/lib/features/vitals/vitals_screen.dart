import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import '../../services/health_service.dart';
import '../../models/user_vitals.dart';

class VitalsScreen extends StatefulWidget {
  const VitalsScreen({super.key});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  final HealthService _healthService = HealthService();
  UserVitals? _vitals;
  bool _isLoading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _fetchVitals();
  }

  Future<void> _fetchVitals() async {
    setState(() {
      _isLoading = true;
      _status = '';
    });

    final now = DateTime.now();
    final vitals = await _healthService.fetchAllVitals(
      startTime: now.subtract(const Duration(days: 1)),
      endTime: now,
    );

    if (mounted) {
      final l = AppLocalizations.of(context)!;
      setState(() {
        _vitals = vitals;
        _isLoading = false;
        if (vitals == null) {
          _status = l.authorizeHealthConnect;
        }
      });
    }
  }

  Future<void> _writeMockData() async {
    final l = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
      _status = l.writingMockData;
    });

    final success = await _healthService.writeMockData();

    if (mounted) {
      final l2 = AppLocalizations.of(context)!;
      setState(() {
        _isLoading = false;
        _status = success ? l2.mockDataInjected : l2.failedToInjectMock;
      });
      if (success) _fetchVitals();
    }
  }

  Widget _buildVitalTile(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(26), // ~0.1 opacity
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchVitals,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l.dailyStats,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_vitals != null) ...[
                    _buildVitalTile(
                      l.steps,
                      '${_vitals!.todaySteps}',
                      Icons.directions_walk,
                      Colors.teal,
                    ),
                    _buildVitalTile(
                      l.calories,
                      '${_vitals!.todayCalories.toStringAsFixed(1)} kcal',
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                    _buildVitalTile(
                      l.activeMinutes,
                      '${_vitals!.todayActiveMinutes} min',
                      Icons.timer,
                      Colors.green,
                    ),
                    const Divider(height: 32),
                    Text(
                      l.latestReadings,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildVitalTile(
                      l.heartRate,
                      _vitals!.latestHeartRate,
                      Icons.favorite,
                      Colors.red,
                    ),
                    _buildVitalTile(
                      l.bloodPressure,
                      _vitals!.latestBloodPressure,
                      Icons.speed,
                      Colors.blue,
                    ),
                    _buildVitalTile(
                      l.glucose,
                      _vitals!.latestGlucose,
                      Icons.bloodtype,
                      Colors.purple,
                    ),
                    _buildVitalTile(
                      l.sleep,
                      _vitals!.latestSleep,
                      Icons.nights_stay,
                      Colors.indigo,
                    ),
                    _buildVitalTile(
                      l.spo2,
                      _vitals!.latestSpo2,
                      Icons.air,
                      Colors.cyan,
                    ),
                    _buildVitalTile(
                      l.stress,
                      _vitals!.latestStress,
                      Icons.psychology,
                      Colors.amber,
                    ),
                  ] else ...[
                    Center(child: Text(l.noDataFound)),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _fetchVitals,
                    icon: const Icon(Icons.refresh),
                    label: Text(l.refreshData),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _writeMockData,
                    icon: const Icon(Icons.add),
                    label: Text(l.insertMockData),
                  ),
                  if (_status.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _status.contains('fail')
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
