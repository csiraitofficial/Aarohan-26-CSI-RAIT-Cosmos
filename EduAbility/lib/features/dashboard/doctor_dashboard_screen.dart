import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';
import '../../services/api_service.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _tabIndex = 0;

  void _refreshAll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.doctorDashboard)),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          DoctorProfileTab(key: UniqueKey()),
          DoctorAppointmentsTab(onRefreshNeeded: _refreshAll),
          const DoctorPatientsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l.profile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: l.appointments,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: l.patients,
          ),
        ],
      ),
    );
  }
}

class DoctorProfileTab extends StatelessWidget {
  const DoctorProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        ApiService().getDoctorInfo(ApiService.currentDoctorId ?? ''),
        ApiService().getDoctorAppointments(ApiService.currentDoctorId ?? ''),
        ApiService().getDoctorPatients(ApiService.currentDoctorId ?? ''),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Center(child: Text(l.failedToLoadProfile));
        }

        final doctorInfo = snapshot.data![0] as Map<String, dynamic>?;
        final appointments = snapshot.data![1] as List<dynamic>? ?? [];
        final patients = snapshot.data![2] as List<dynamic>? ?? [];

        if (doctorInfo == null) {
          return Center(child: Text(l.doctorInfoNotFound));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      doctorInfo['name'] ?? 'Doctor Name',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctorInfo['degree'] ?? 'Degree',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            doctorInfo['mobile'] ?? '-',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Statistics Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      l.totalPatients,
                      patients.length.toString(),
                      Icons.people_outline,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      l.appointments,
                      appointments.length.toString(),
                      Icons.calendar_month_outlined,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions or Additional Info
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.practiceDetails,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        Icons.location_on_outlined,
                        l.clinicLocation,
                        l.signifyMedicalCenter,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        Icons.access_time,
                        l.availableHours,
                        '09:00 AM - 05:00 PM',
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        Icons.verified_user_outlined,
                        l.doctorId,
                        '#${ApiService.currentDoctorId}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}

class DoctorAppointmentsTab extends StatefulWidget {
  final VoidCallback? onRefreshNeeded;
  const DoctorAppointmentsTab({super.key, this.onRefreshNeeded});

  @override
  State<DoctorAppointmentsTab> createState() => _DoctorAppointmentsTabState();
}

class _DoctorAppointmentsTabState extends State<DoctorAppointmentsTab> {
  late Future<List<dynamic>?> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = ApiService().getDoctorAppointments(
      ApiService.currentDoctorId ?? '',
    );
  }

  void _reloadAppointments() {
    setState(() {
      _appointmentsFuture = ApiService().getDoctorAppointments(
        ApiService.currentDoctorId ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l.reloadAppointments,
                onPressed: _reloadAppointments,
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<dynamic>?>(
            future: _appointmentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final appointments = snapshot.data ?? [];
              if (appointments.isEmpty) {
                return Center(child: Text(l.noAppointments));
              }
              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, idx) {
                  final appt = appointments[idx];
                  final dynamic confirmedData = appt['confirmed'];
                  final bool confirmed =
                      confirmedData == true ||
                      confirmedData == 1 ||
                      confirmedData == 'true';

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        appt['name'] ?? appt['patient_id'] ?? '-',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(l.timeLabel(appt['time'] ?? '-')),
                      trailing: confirmed
                          ? Chip(
                              label: Text(l.confirmed),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final success = await ApiService()
                                    .confirmAppointment(
                                      appt['appointment_id'].toString(),
                                    );
                                if (success) {
                                  _reloadAppointments();
                                  if (widget.onRefreshNeeded != null) {
                                    widget.onRefreshNeeded!();
                                  }
                                }
                              },
                              child: Text(l.confirm),
                            ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class DoctorPatientsTab extends StatefulWidget {
  const DoctorPatientsTab({super.key});

  @override
  State<DoctorPatientsTab> createState() => _DoctorPatientsTabState();
}

class _DoctorPatientsTabState extends State<DoctorPatientsTab> {
  late Future<List<dynamic>?> _patientsFuture;
  bool _sortByPriority = false;

  @override
  void initState() {
    super.initState();
    _patientsFuture = ApiService().getDoctorPatients(
      ApiService.currentDoctorId ?? '',
    );
  }

  void _reloadPatients() {
    setState(() {
      _patientsFuture = ApiService().getDoctorPatients(
        ApiService.currentDoctorId ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.myPatients,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ChoiceChip(
                    label: Text(l.prioritySort),
                    selected: _sortByPriority,
                    onSelected: (val) => setState(() => _sortByPriority = val),
                    selectedColor: Colors.red.shade100,
                    checkmarkColor: Colors.red,
                    labelStyle: TextStyle(
                      color: _sortByPriority
                          ? Colors.red
                          : Colors.grey.shade700,
                      fontWeight: _sortByPriority
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: l.reloadPatients,
                    onPressed: _reloadPatients,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<dynamic>?>(
            future: _patientsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              List<dynamic> patients = snapshot.data ?? [];
              if (patients.isEmpty) {
                return Center(child: Text(l.noPatients));
              }

              if (_sortByPriority) {
                patients.sort((a, b) {
                  final int pA =
                      int.tryParse(a['priority']?.toString() ?? '0') ?? 0;
                  final int pB =
                      int.tryParse(b['priority']?.toString() ?? '0') ?? 0;
                  return pB.compareTo(pA); // High priority first
                });
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: patients.length,
                itemBuilder: (context, idx) {
                  final patient = patients[idx];
                  final int priorityLevel =
                      int.tryParse(patient['priority']?.toString() ?? '0') ?? 0;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        patient['name'] ?? patient['patient_id'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${patient['patient_id']}'),
                          const SizedBox(height: 4),
                          if (priorityLevel > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(
                                  priorityLevel,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getPriorityColor(priorityLevel),
                                ),
                              ),
                              child: Text(
                                l.priorityLevel(priorityLevel.toString()),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getPriorityColor(priorityLevel),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/doctor_patient_vitals',
                          arguments: patient['patient_id'],
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(int level) {
    if (level >= 3) return Colors.red;
    if (level >= 2) return Colors.orange;
    return Colors.green;
  }
}
