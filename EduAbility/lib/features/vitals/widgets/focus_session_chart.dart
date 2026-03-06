import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_data_service.dart';
import 'package:mobile/services/disability_provider.dart';

class FocusSessionChart extends StatefulWidget {
  const FocusSessionChart({super.key});

  @override
  State<FocusSessionChart> createState() => _FocusSessionChartState();
}

class _FocusSessionChartState extends State<FocusSessionChart> {
  List<FocusSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await DisabilityDataService.loadFocusSessions();
    if (data.isEmpty) {
      await DisabilityDataService.generateMockData(DisabilityType.adhd);
      data = await DisabilityDataService.loadFocusSessions();
    }
    if (mounted) setState(() { _sessions = data; _isLoading = false; });
  }

  void _showLogSheet() {
    double focusMins = 25;
    double breakMins = 5;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Focus Session', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Focus: ${focusMins.toInt()} min'),
              Slider(value: focusMins, min: 5, max: 90, divisions: 17, onChanged: (v) => setSheetState(() => focusMins = v)),
              Text('Break: ${breakMins.toInt()} min'),
              Slider(value: breakMins, min: 0, max: 30, divisions: 6, onChanged: (v) => setSheetState(() => breakMins = v)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _sessions.add(FocusSession(startTime: DateTime.now(), durationMinutes: focusMins.toInt(), breakMinutes: breakMins.toInt()));
                    await DisabilityDataService.saveFocusSessions(_sessions);
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
    if (_sessions.isEmpty) return _emptyCard(context);

    final now = DateTime.now();
    final dailyData = <_DayFocus>[];
    int totalFocus = 0;
    for (int d = 6; d >= 0; d--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: d));
      final daySessions = _sessions.where((s) =>
        s.startTime.year == date.year && s.startTime.month == date.month && s.startTime.day == date.day,
      ).toList();
      final focus = daySessions.fold(0, (sum, s) => sum + s.durationMinutes);
      final brk = daySessions.fold(0, (sum, s) => sum + s.breakMinutes);
      totalFocus += focus;
      dailyData.add(_DayFocus(date, focus, brk));
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
                Expanded(child: Text('Focus Sessions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.indigo), onPressed: _showLogSheet, tooltip: 'Log Session'),
              ],
            ),
            Text('Avg: ${(totalFocus / 7).round()} min/day', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                primaryXAxis: DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(minimum: 0),
                series: <CartesianSeries<_DayFocus, DateTime>>[
                  StackedColumnSeries<_DayFocus, DateTime>(
                    name: 'Focus',
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.focusMin,
                    color: Colors.indigo,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    width: 0.5,
                  ),
                  StackedColumnSeries<_DayFocus, DateTime>(
                    name: 'Break',
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.breakMin,
                    color: Colors.lightBlue.shade200,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    width: 0.5,
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
        Icon(Icons.timer, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text('No focus sessions logged', style: TextStyle(color: Colors.grey.shade600)),
      ]),
    ),
  );
}

class _DayFocus {
  final DateTime date;
  final int focusMin;
  final int breakMin;
  const _DayFocus(this.date, this.focusMin, this.breakMin);
}
