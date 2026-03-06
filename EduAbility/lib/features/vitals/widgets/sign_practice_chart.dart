import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_data_service.dart';
import 'package:mobile/services/disability_provider.dart';

class SignPracticeChart extends StatefulWidget {
  const SignPracticeChart({super.key});

  @override
  State<SignPracticeChart> createState() => _SignPracticeChartState();
}

class _SignPracticeChartState extends State<SignPracticeChart> {
  List<SignPracticeEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await DisabilityDataService.loadSignPractice();
    if (data.isEmpty) {
      await DisabilityDataService.generateMockData(DisabilityType.deafMute);
      data = await DisabilityDataService.loadSignPractice();
    }
    if (mounted) setState(() { _entries = data; _isLoading = false; });
  }

  void _showLogSheet() {
    double practice = 15;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Sign Practice', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Practice: ${practice.toInt()} min'),
              Slider(value: practice, min: 5, max: 60, divisions: 11, onChanged: (v) => setSheetState(() => practice = v)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _entries.add(SignPracticeEntry(
                      date: DateTime.now(),
                      practiceMinutes: practice.toInt(),
                      goalMinutes: 30,
                    ));
                    await DisabilityDataService.saveSignPractice(_entries);
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
    if (_entries.isEmpty) return _emptyCard(context);

    final now = DateTime.now();
    final dailyData = <_DayPractice>[];
    int daysGoalMet = 0;
    for (int d = 6; d >= 0; d--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: d));
      final dayEntries = _entries.where((e) =>
        e.date.year == date.year && e.date.month == date.month && e.date.day == date.day,
      ).toList();
      final totalPractice = dayEntries.fold(0, (sum, e) => sum + e.practiceMinutes);
      final goal = dayEntries.isNotEmpty ? dayEntries.first.goalMinutes : 30;
      if (totalPractice >= goal) daysGoalMet++;
      dailyData.add(_DayPractice(date, totalPractice, goal));
    }

    final todayData = dailyData.last;
    final todayPercent = (todayData.practice / todayData.goal * 100).clamp(0, 100).round();

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
                Expanded(child: Text('Sign Language Practice', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.teal), onPressed: _showLogSheet, tooltip: 'Log Practice'),
              ],
            ),
            Row(
              children: [
                Text('Today: $todayPercent%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: todayPercent >= 100 ? Colors.green : Colors.teal)),
                const SizedBox(width: 12),
                Text('$daysGoalMet/7 days goal met', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(minimum: 0, title: AxisTitle(text: 'Minutes')),
                series: <CartesianSeries<_DayPractice, DateTime>>[
                  ColumnSeries<_DayPractice, DateTime>(
                    name: 'Practice',
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.practice,
                    pointColorMapper: (d, _) => d.practice >= d.goal ? Colors.green : Colors.teal.shade300,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    width: 0.5,
                  ),
                  LineSeries<_DayPractice, DateTime>(
                    name: 'Goal',
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.goal,
                    color: Colors.red.shade300,
                    dashArray: const <double>[5, 3],
                    width: 2,
                  ),
                ],
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
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
        Text('No sign practice logged', style: TextStyle(color: Colors.grey.shade600)),
      ]),
    ),
  );
}

class _DayPractice {
  final DateTime date;
  final int practice;
  final int goal;
  const _DayPractice(this.date, this.practice, this.goal);
}
