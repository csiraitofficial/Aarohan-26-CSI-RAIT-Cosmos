import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_data_service.dart';
import 'package:mobile/services/disability_provider.dart';

class TaskCompletionChart extends StatefulWidget {
  const TaskCompletionChart({super.key});

  @override
  State<TaskCompletionChart> createState() => _TaskCompletionChartState();
}

class _TaskCompletionChartState extends State<TaskCompletionChart> {
  List<TaskEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await DisabilityDataService.loadTaskEntries();
    if (data.isEmpty) {
      await DisabilityDataService.generateMockData(DisabilityType.adhd);
      data = await DisabilityDataService.loadTaskEntries();
    }
    if (mounted) setState(() { _entries = data; _isLoading = false; });
  }

  void _showLogSheet() {
    int planned = 5;
    int completed = 3;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Today\'s Tasks', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _stepper('Planned', planned, (v) => setSheetState(() => planned = v)),
              const SizedBox(height: 8),
              _stepper('Completed', completed, (v) => setSheetState(() => completed = v.clamp(0, planned))),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _entries.add(TaskEntry(date: DateTime.now(), planned: planned, completed: completed));
                    await DisabilityDataService.saveTaskEntries(_entries);
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

  Widget _stepper(String label, int value, ValueChanged<int> onChange) => Row(
    children: [
      SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: value > 0 ? () => onChange(value - 1) : null),
      Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => onChange(value + 1)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox.shrink();
    if (_entries.isEmpty) return _emptyCard(context);

    final totalPlanned = _entries.fold(0, (s, e) => s + e.planned);
    final totalCompleted = _entries.fold(0, (s, e) => s + e.completed);
    final pct = totalPlanned > 0 ? (totalCompleted / totalPlanned * 100).round() : 0;

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
                Expanded(child: Text('Task Completion', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.green), onPressed: _showLogSheet, tooltip: 'Log Tasks'),
              ],
            ),
            Text('$totalCompleted/$totalPlanned tasks this week ($pct%)', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                primaryXAxis: DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(minimum: 0),
                series: <CartesianSeries<TaskEntry, DateTime>>[
                  ColumnSeries<TaskEntry, DateTime>(
                    name: 'Planned',
                    dataSource: _entries,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.planned,
                    color: Colors.grey.shade400,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    width: 0.35,
                  ),
                  ColumnSeries<TaskEntry, DateTime>(
                    name: 'Completed',
                    dataSource: _entries,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.completed,
                    color: const Color(0xFF4CAF50),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    width: 0.35,
                  ),
                ],
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
        Icon(Icons.task_alt, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text('No task data logged', style: TextStyle(color: Colors.grey.shade600)),
      ]),
    ),
  );
}
