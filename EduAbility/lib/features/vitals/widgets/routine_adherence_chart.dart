import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:mobile/models/disability_tracking_data.dart';
import 'package:mobile/services/disability_data_service.dart';
import 'package:mobile/services/disability_provider.dart';

class RoutineAdherenceChart extends StatefulWidget {
  const RoutineAdherenceChart({super.key});

  @override
  State<RoutineAdherenceChart> createState() => _RoutineAdherenceChartState();
}

class _RoutineAdherenceChartState extends State<RoutineAdherenceChart> {
  List<RoutineItem> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var data = await DisabilityDataService.loadRoutineItems();
    if (data.isEmpty) {
      await DisabilityDataService.generateMockData(DisabilityType.autistic);
      data = await DisabilityDataService.loadRoutineItems();
    }
    if (mounted) setState(() { _allItems = data; _isLoading = false; });
  }

  List<RoutineItem> get _todayItems {
    final now = DateTime.now();
    return _allItems.where((i) =>
      i.date.year == now.year && i.date.month == now.month && i.date.day == now.day,
    ).toList();
  }

  Future<void> _toggleItem(int index) async {
    final today = _todayItems;
    if (index >= today.length) return;
    final item = today[index];
    final globalIdx = _allItems.indexOf(item);
    if (globalIdx < 0) return;
    _allItems[globalIdx] = item.copyWith(completed: !item.completed);
    await DisabilityDataService.saveRoutineItems(_allItems);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox.shrink();

    var today = _todayItems;
    // If no items for today, create defaults
    if (today.isEmpty) {
      final now = DateTime.now();
      final date = DateTime(now.year, now.month, now.day);
      for (final name in RoutineItem.defaultItems) {
        _allItems.add(RoutineItem(name: name, completed: false, date: date));
      }
      DisabilityDataService.saveRoutineItems(_allItems);
      today = _todayItems;
    }

    final completed = today.where((i) => i.completed).length;
    final total = today.length;
    final pct = total > 0 ? (completed / total * 100).round() : 0;

    final chartData = [
      _SegData('Done', completed.toDouble(), Colors.teal),
      _SegData('Remaining', (total - completed).toDouble(), Colors.grey.shade300),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Routine Adherence', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SfCircularChart(
                      margin: EdgeInsets.zero,
                      annotations: <CircularChartAnnotation>[
                        CircularChartAnnotation(
                          widget: Text(
                            '$pct%',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: pct >= 80 ? Colors.teal : pct >= 50 ? Colors.orange : Colors.red),
                          ),
                        ),
                      ],
                      series: <CircularSeries<_SegData, String>>[
                        DoughnutSeries<_SegData, String>(
                          dataSource: chartData,
                          xValueMapper: (d, _) => d.label,
                          yValueMapper: (d, _) => d.value,
                          pointColorMapper: (d, _) => d.color,
                          radius: '85%',
                          innerRadius: '70%',
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(today.length, (i) =>
                        InkWell(
                          onTap: () => _toggleItem(i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                Icon(
                                  today[i].completed ? Icons.check_circle : Icons.circle_outlined,
                                  size: 18,
                                  color: today[i].completed ? Colors.teal : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    today[i].name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: today[i].completed ? Colors.teal.shade700 : Colors.grey.shade600,
                                      decoration: today[i].completed ? TextDecoration.lineThrough : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegData {
  final String label;
  final double value;
  final Color color;
  const _SegData(this.label, this.value, this.color);
}
