import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_data_service.dart';
import 'package:mobile/services/disability_provider.dart';

class SensoryEventChart extends StatefulWidget {
  const SensoryEventChart({super.key});

  @override
  State<SensoryEventChart> createState() => _SensoryEventChartState();
}

class _SensoryEventChartState extends State<SensoryEventChart> {
  List<SensoryEvent> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await DisabilityDataService.loadSensoryEvents();
    if (data.isEmpty) {
      await DisabilityDataService.generateMockData(DisabilityType.autistic);
      data = await DisabilityDataService.loadSensoryEvents();
    }
    if (mounted) setState(() { _events = data; _isLoading = false; });
  }

  void _showLogSheet() {
    int severity = 2;
    String trigger = 'unknown';
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Sensory Event', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Severity', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 1, label: Text('Mild')),
                  ButtonSegment(value: 2, label: Text('Moderate')),
                  ButtonSegment(value: 3, label: Text('Severe')),
                ],
                selected: {severity},
                onSelectionChanged: (s) => setSheetState(() => severity = s.first),
              ),
              const SizedBox(height: 16),
              Text('Trigger', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['noise', 'light', 'touch', 'change', 'unknown'].map((t) =>
                  ChoiceChip(
                    label: Text(t[0].toUpperCase() + t.substring(1)),
                    selected: trigger == t,
                    onSelected: (_) => setSheetState(() => trigger = t),
                  ),
                ).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _events.add(SensoryEvent(timestamp: DateTime.now(), severity: severity, trigger: trigger));
                    await DisabilityDataService.saveSensoryEvents(_events);
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
    if (_events.isEmpty) return _emptyCard(context);

    // Aggregate by day
    final now = DateTime.now();
    final dailyData = <_DayData>[];
    for (int d = 6; d >= 0; d--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: d));
      final dayEvents = _events.where((e) =>
        e.timestamp.year == date.year && e.timestamp.month == date.month && e.timestamp.day == date.day,
      ).toList();
      final avgSev = dayEvents.isEmpty ? 0.0 : dayEvents.map((e) => e.severity).reduce((a, b) => a + b) / dayEvents.length;
      dailyData.add(_DayData(date, dayEvents.length, avgSev));
    }

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
                Expanded(child: Text('Sensory / Meltdown Events', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.teal), onPressed: _showLogSheet, tooltip: 'Log Event'),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                primaryYAxis: NumericAxis(minimum: 0, interval: 1),
                series: <CartesianSeries<_DayData, DateTime>>[
                  ColumnSeries<_DayData, DateTime>(
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.count,
                    pointColorMapper: (d, _) => d.avgSeverity < 1.5
                        ? const Color(0xFF4CAF50)
                        : d.avgSeverity < 2.5
                            ? const Color(0xFFFFC107)
                            : const Color(0xFFF44336),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    width: 0.5,
                  ),
                ],
              ),
            ),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(const Color(0xFF4CAF50), 'Mild'),
                const SizedBox(width: 12),
                _legendDot(const Color(0xFFFFC107), 'Moderate'),
                const SizedBox(width: 12),
                _legendDot(const Color(0xFFF44336), 'Severe'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
    ],
  );

  Widget _emptyCard(BuildContext context) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Icon(Icons.psychology, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text('No sensory events logged', style: TextStyle(color: Colors.grey.shade600)),
      ]),
    ),
  );
}

class _DayData {
  final DateTime date;
  final int count;
  final double avgSeverity;
  const _DayData(this.date, this.count, this.avgSeverity);
}
