import 'package:flutter/material.dart';
import 'package:mobile/services/health_service.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/models/user_vitals.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'signify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final HealthService _healthService = HealthService();
  final ApiService _apiService = ApiService();

  UserVitals? _vitals;
  bool _isLoading = false;
  String _syncStatus = '';

  Future<void> _fetchVitals() async {
    setState(() {
      _isLoading = true;
      _syncStatus = '';
    });

    final now = DateTime.now();
    final vitals = await _healthService.fetchAllVitals(
      startTime: now.subtract(const Duration(days: 1)),
      endTime: now,
    );

    setState(() {
      _vitals = vitals;
      _isLoading = false;
      if (vitals == null) {
        // The exception caught in the service suggests Health Connect might not be installed.
        _syncStatus = 'Please install Health Connect and grant permissions.';
      }
    });
  }

  Future<void> _syncToServer() async {
    if (_vitals == null) return;

    setState(() {
      _isLoading = true;
      _syncStatus = 'Syncing...';
    });

    final success = await _apiService.syncVitals(_vitals!);

    setState(() {
      _isLoading = false;
      _syncStatus = success ? 'Synced successfully!' : 'Sync failed.';
    });
  }

  Future<void> _writeMockData() async {
    setState(() {
      _isLoading = true;
      _syncStatus = 'Writing mock data...';
    });

    final success = await _healthService.writeMockData();

    setState(() {
      _isLoading = false;
      _syncStatus = success
          ? 'Mock data injected into Health Connect!'
          : 'Failed to inject mock data.';
    });
  }

  Widget _buildVitalCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vitals Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (_vitals != null) ...[
                  _buildVitalCard(
                    'Heart Rate',
                    _vitals!.heartRates.isNotEmpty
                        ? '${_vitals!.heartRates.first.value} bpm'
                        : 'N/A',
                    Icons.favorite,
                    Colors.red,
                  ),
                  _buildVitalCard(
                    'Blood Pressure',
                    _vitals!.bloodPressures.isNotEmpty
                        ? '${_vitals!.bloodPressures.first.systolic}/${_vitals!.bloodPressures.first.diastolic} mmHg'
                        : 'N/A',
                    Icons.favorite_border,
                    Colors.blue,
                  ),
                  _buildVitalCard(
                    'Blood Glucose',
                    _vitals!.bloodGlucose.isNotEmpty
                        ? '${_vitals!.bloodGlucose.first.value} mg/dL'
                        : 'N/A',
                    Icons.water_drop,
                    Colors.orange,
                  ),
                  _buildVitalCard(
                    'Sleep Duration',
                    _vitals!.sleepSessionsMinutes.isNotEmpty
                        ? '${_vitals!.sleepSessionsMinutes.first.value} min'
                        : 'N/A',
                    Icons.bedtime,
                    Colors.purple,
                  ),
                  _buildVitalCard(
                    'Steps',
                    _vitals!.steps.isNotEmpty
                        ? '${_vitals!.steps.first.value}'
                        : 'N/A',
                    Icons.directions_walk,
                    Colors.teal,
                  ),
                  _buildVitalCard(
                    'Calories Burned',
                    _vitals!.caloriesBurned.isNotEmpty
                        ? '${_vitals!.caloriesBurned.first.value.toStringAsFixed(1)} kcal'
                        : 'N/A',
                    Icons.local_fire_department,
                    Colors.deepOrange,
                  ),
                  _buildVitalCard(
                    'Active Minutes',
                    _vitals!.activeMinutes.isNotEmpty
                        ? '${_vitals!.activeMinutes.first.value} min'
                        : 'N/A',
                    Icons.directions_run,
                    Colors.green,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _syncToServer,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Sync with Server'),
                  ),
                ] else ...[
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'No vitals data fetched yet. Please authorize Health Connect and fetch data.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _fetchVitals,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Fetch Local Vitals'),
                ),
                ElevatedButton.icon(
                  onPressed: _writeMockData,
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Insert Mock Vitals (Testing)'),
                ),
                if (_syncStatus.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    _syncStatus,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _syncStatus.contains('success') ||
                              _syncStatus.contains('Mock')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}
