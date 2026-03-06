import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_data_service.dart';
import 'package:mobile/services/disability_provider.dart';

class CommunicationLogChart extends StatefulWidget {
  const CommunicationLogChart({super.key});

  @override
  State<CommunicationLogChart> createState() => _CommunicationLogChartState();
}

class _CommunicationLogChartState extends State<CommunicationLogChart> {
  List<CommunicationLog> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await DisabilityDataService.loadCommunicationLogs();
    if (data.isEmpty) {
      await DisabilityDataService.generateMockData(DisabilityType.deafMute);
      data = await DisabilityDataService.loadCommunicationLogs();
    }
    if (mounted) setState(() { _logs = data; _isLoading = false; });
  }

  void _showLogSheet() {
    String method = 'sign_language';
    double duration = 15;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Communication', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Method:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: CommunicationLog.methods.map((m) => ChoiceChip(
                  label: Text(CommunicationLog.methodLabels[m] ?? m),
                  selected: method == m,
                  onSelected: (sel) { if (sel) setSheetState(() => method = m); },
                )).toList(),
              ),
              const SizedBox(height: 12),
              Text('Duration: ${duration.toInt()} min'),
              Slider(value: duration, min: 1, max: 120, divisions: 23, onChanged: (v) => setSheetState(() => duration = v)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _logs.add(CommunicationLog(
                      timestamp: DateTime.now(),
                      method: method,
                      durationMinutes: duration.toInt(),
                    ));
                    await DisabilityDataService.saveCommunicationLogs(_logs);
                    if (mounted) setState(() {});
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox.shrink();
    if (_logs.isEmpty) return _emptyCard(context);

    final now = DateTime.now();
    final dailyData = <_DayComm>[];
    for (int d = 6; d >= 0; d--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: d));
      final dayLogs = _logs.where((l) =>
        l.timestamp.year == date.year && l.timestamp.month == date.month && l.timestamp.day == date.day,
      ).toList();
      final methodMins = <String, int>{};
      for (final m in CommunicationLog.methods) {
        methodMins[m] = dayLogs.where((l) => l.method == m).fold(0, (sum, l) => sum + l.durationMinutes);
      }
      dailyData.add(_DayComm(date, methodMins));
    }

    final methodColors = {
      'sign_language': Colors.teal,
      'text': Colors.blue,
      'lip_reading': Colors.orange,
      'gesture': Colors.purple,
    };

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text('Communication Methods', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.teal), onPressed: _showLogSheet, tooltip: 'Log Communication'),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                primaryXAxis: DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(minimum: 0, title: AxisTitle(text: 'Minutes')),
                series: CommunicationLog.methods.map((method) =>
                  StackedColumnSeries<_DayComm, DateTime>(
                    name: CommunicationLog.methodLabels[method] ?? method,
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.methodMins[method] ?? 0,
                    color: methodColors[method] ?? Colors.grey,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                    width: 0.5,
                  ),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard(BuildContext context) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Icon(Icons.sign_language, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text('No communication logs yet', style: TextStyle(color: Colors.grey.shade600)),
      ]),
    ),
  );
}

class _DayComm {
  final DateTime date;
  final Map<String, int> methodMins;
  const _DayComm(this.date, this.methodMins);
}
