import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_data_service.dart';
import 'package:mobile/services/disability_provider.dart';

class ReadingSessionChart extends StatefulWidget {
  const ReadingSessionChart({super.key});

  @override
  State<ReadingSessionChart> createState() => _ReadingSessionChartState();
}

class _ReadingSessionChartState extends State<ReadingSessionChart> {
  List<ReadingSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await DisabilityDataService.loadReadingSessions();
    if (data.isEmpty) {
      await DisabilityDataService.generateMockData(DisabilityType.dyslexia);
      data = await DisabilityDataService.loadReadingSessions();
    }
    if (mounted) setState(() { _sessions = data; _isLoading = false; });
  }

  void _showLogSheet() {
    double duration = 20;
    int comprehension = 3;
    double wpm = 100;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Log Reading Session', style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('Duration: ${duration.toInt()} min'),
              Slider(value: duration, min: 5, max: 60, divisions: 11, onChanged: (v) => setSheetState(() => duration = v)),
              Text('Words per Minute: ${wpm.toInt()}'),
              Slider(value: wpm, min: 30, max: 250, divisions: 22, onChanged: (v) => setSheetState(() => wpm = v)),
              Text('Comprehension: $comprehension / 5'),
              Row(
                children: List.generate(5, (i) => IconButton(
                  icon: Icon(i < comprehension ? Icons.star : Icons.star_border, color: Colors.amber),
                  onPressed: () => setSheetState(() => comprehension = i + 1),
                )),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _sessions.add(ReadingSession(
                      date: DateTime.now(),
                      durationMinutes: duration.toInt(),
                      comprehensionRating: comprehension,
                      wordsPerMinute: wpm.toInt(),
                    ));
                    await DisabilityDataService.saveReadingSessions(_sessions);
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
    final dailyData = <_DayReading>[];
    for (int d = 6; d >= 0; d--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: d));
      final daySessions = _sessions.where((s) =>
        s.date.year == date.year && s.date.month == date.month && s.date.day == date.day,
      ).toList();
      final totalMin = daySessions.fold(0, (sum, s) => sum + s.durationMinutes);
      final avgComp = daySessions.isEmpty ? 0.0 : daySessions.fold(0, (sum, s) => sum + s.comprehensionRating) / daySessions.length;
      dailyData.add(_DayReading(date, totalMin, avgComp));
    }

    final avgDuration = dailyData.fold(0, (sum, d) => sum + d.minutes) / 7;

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
                Expanded(child: Text('Reading Sessions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
                IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.deepPurple), onPressed: _showLogSheet, tooltip: 'Log Session'),
              ],
            ),
            Text('Avg: ${avgDuration.round()} min/day', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                primaryXAxis: DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(minimum: 0, title: AxisTitle(text: 'Minutes')),
                axes: <ChartAxis>[
                  NumericAxis(
                    name: 'compAxis',
                    opposedPosition: true,
                    minimum: 0,
                    maximum: 5,
                    title: AxisTitle(text: 'Rating'),
                  ),
                ],
                series: <CartesianSeries>[
                  ColumnSeries<_DayReading, DateTime>(
                    name: 'Duration',
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.minutes,
                    color: Colors.deepPurple.shade300,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    width: 0.5,
                  ),
                  SplineSeries<_DayReading, DateTime>(
                    name: 'Comprehension',
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.comprehension,
                    yAxisName: 'compAxis',
                    color: Colors.amber,
                    width: 2.5,
                    markerSettings: const MarkerSettings(isVisible: true, height: 6, width: 6),
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
        Icon(Icons.menu_book, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text('No reading sessions logged', style: TextStyle(color: Colors.grey.shade600)),
      ]),
    ),
  );
}

class _DayReading {
  final DateTime date;
  final int minutes;
  final double comprehension;
  const _DayReading(this.date, this.minutes, this.comprehension);
}
