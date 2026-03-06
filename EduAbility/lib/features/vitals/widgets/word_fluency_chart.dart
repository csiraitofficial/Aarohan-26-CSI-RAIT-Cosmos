import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_data_service.dart';
import 'package:mobile/services/disability_provider.dart';

class WordFluencyChart extends StatefulWidget {
  const WordFluencyChart({super.key});

  @override
  State<WordFluencyChart> createState() => _WordFluencyChartState();
}

class _WordFluencyChartState extends State<WordFluencyChart> {
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox.shrink();
    if (_sessions.isEmpty) return _emptyCard(context);

    final now = DateTime.now();
    final dailyData = <_DayWpm>[];
    for (int d = 6; d >= 0; d--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: d));
      final daySessions = _sessions.where((s) =>
        s.date.year == date.year && s.date.month == date.month && s.date.day == date.day,
      ).toList();
      if (daySessions.isNotEmpty) {
        final avgWpm = daySessions.fold(0, (sum, s) => sum + s.wordsPerMinute) / daySessions.length;
        dailyData.add(_DayWpm(date, avgWpm));
      }
    }

    if (dailyData.isEmpty) return _emptyCard(context);

    final latestWpm = dailyData.last.wpm;
    final firstWpm = dailyData.first.wpm;
    final trending = latestWpm >= firstWpm;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Word Fluency (WPM)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text('${latestWpm.round()} WPM', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                const SizedBox(width: 8),
                Icon(trending ? Icons.trending_up : Icons.trending_down, color: trending ? Colors.green : Colors.red, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: DateTimeAxis(majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(minimum: 0),
                series: <CartesianSeries<_DayWpm, DateTime>>[
                  SplineSeries<_DayWpm, DateTime>(
                    dataSource: dailyData,
                    xValueMapper: (d, _) => d.date,
                    yValueMapper: (d, _) => d.wpm,
                    color: Colors.deepPurple,
                    width: 2.5,
                    markerSettings: const MarkerSettings(isVisible: true, height: 8, width: 8),
                  ),
                ],
                annotations: <CartesianChartAnnotation>[
                  CartesianChartAnnotation(
                    widget: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text('Target: 150 WPM', style: TextStyle(fontSize: 10, color: Colors.green.shade700)),
                    ),
                    coordinateUnit: CoordinateUnit.point,
                    x: dailyData.last.date,
                    y: 150,
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
        Icon(Icons.text_fields, size: 40, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text('No word fluency data yet', style: TextStyle(color: Colors.grey.shade600)),
      ]),
    ),
  );
}

class _DayWpm {
  final DateTime date;
  final double wpm;
  const _DayWpm(this.date, this.wpm);
}
