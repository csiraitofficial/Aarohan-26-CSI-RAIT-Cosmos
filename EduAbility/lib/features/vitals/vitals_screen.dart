import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import '../../services/health_service.dart';
import '../../services/disability_provider.dart';
import '../../models/user_vitals.dart';
import 'vitals_dashboard_screen.dart';

class VitalsScreen extends StatefulWidget {
  final VoidCallback? onTestEmergency;

  const VitalsScreen({super.key, this.onTestEmergency});

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
      startTime: now.subtract(const Duration(days: 7)),
      endTime: now,
    );

    if (mounted) {
      setState(() {
        // Use real data if available, otherwise fallback to demo
        _vitals = vitals ?? HealthService.generateDemoVitals();
        _isLoading = false;
        if (vitals == null) {
          _status = 'Using demo data (Health Connect unavailable)';
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

  void _loadDemoData() {
    setState(() {
      _vitals = HealthService.generateDemoVitals();
      _status = 'Demo data loaded';
    });
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
                  // Test emergency alert button
                  if (widget.onTestEmergency != null) ...[
                    InkWell(
                      onTap: widget.onTestEmergency,
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
                            Icon(
                              Icons.science,
                              color: Colors.red.shade700,
                              size: 28,
                            ),
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
                            Icon(
                              Icons.chevron_right,
                              color: Colors.red.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Disability profile selector
                  Consumer<DisabilityProvider>(
                    builder: (context, dp, _) {
                      final disability = dp.disability;
                      final color = _disabilityColor(disability);
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(0.2),
                              color.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: color.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.accessibility_new_rounded,
                                  color: color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Disability Profile',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: color.withOpacity(1.0),
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    if (disability != DisabilityType.none)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          _disabilityDescription(disability),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: color.withOpacity(0.8),
                                            height: 1.2,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).cardColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: color.withOpacity(0.4),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<DisabilityType>(
                                    value: disability,
                                    isDense: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 20,
                                      color: color,
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    items: DisabilityType.values.map((type) {
                                      return DropdownMenuItem(
                                        value: type,
                                        child: Text(
                                          DisabilityProvider.labels[type]!,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null)
                                        dp.setDisability(value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Dashboard content
                  if (_vitals != null)
                    VitalsDashboardScreen(vitals: _vitals!)
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.monitor_heart_outlined,
                              size: 64,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l.noDataFound,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _fetchVitals,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(l.refreshData),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _loadDemoData,
                          icon: const Icon(Icons.auto_graph, size: 18),
                          label: const Text('Demo Data'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _writeMockData,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l.insertMockData),
                  ),
                  if (_status.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            _status.contains('fail') || _status.contains('Fail')
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Color _disabilityColor(DisabilityType type) {
    switch (type) {
      case DisabilityType.autistic:
        return Colors.teal;
      case DisabilityType.adhd:
        return Colors.deepPurple;
      case DisabilityType.dyslexia:
        return Colors.deepOrange;
      case DisabilityType.deafMute:
        return Colors.blueAccent;
      case DisabilityType.none:
        return Colors.indigo;
    }
  }

  String _disabilityDescription(DisabilityType type) {
    switch (type) {
      case DisabilityType.autistic:
        return 'Sensory events + Routine adherence charts';
      case DisabilityType.adhd:
        return 'Focus sessions + Task completion charts';
      case DisabilityType.dyslexia:
        return 'Reading sessions + Word fluency charts';
      case DisabilityType.deafMute:
        return 'Communication logs + Sign practice charts';
      case DisabilityType.none:
        return '';
    }
  }
}
