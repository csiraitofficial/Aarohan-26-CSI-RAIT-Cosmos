import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RiskScoreGauge extends StatelessWidget {
  final double riskScore;
  final String riskZone;

  const RiskScoreGauge({
    super.key,
    required this.riskScore,
    required this.riskZone,
  });

  Color get _zoneColor {
    switch (riskZone.toLowerCase()) {
      case 'red':
        return const Color(0xFFF44336);
      case 'yellow':
        return const Color(0xFFFFC107);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  String get _zoneLabel {
    switch (riskZone.toLowerCase()) {
      case 'red':
        return 'High Risk';
      case 'yellow':
        return 'Moderate';
      default:
        return 'Healthy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Health Risk Score',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    showLabels: false,
                    showTicks: false,
                    startAngle: 150,
                    endAngle: 30,
                    axisLineStyle: const AxisLineStyle(
                      thickness: 0.15,
                      thicknessUnit: GaugeSizeUnit.factor,
                      color: Color(0xFFE0E0E0),
                    ),
                    ranges: <GaugeRange>[
                      GaugeRange(
                        startValue: 0,
                        endValue: 33,
                        color: const Color(0xFF4CAF50),
                        startWidth: 20,
                        endWidth: 20,
                      ),
                      GaugeRange(
                        startValue: 33,
                        endValue: 66,
                        color: const Color(0xFFFFC107),
                        startWidth: 20,
                        endWidth: 20,
                      ),
                      GaugeRange(
                        startValue: 66,
                        endValue: 100,
                        color: const Color(0xFFF44336),
                        startWidth: 20,
                        endWidth: 20,
                      ),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: riskScore,
                        needleLength: 0.6,
                        lengthUnit: GaugeSizeUnit.factor,
                        needleStartWidth: 1,
                        needleEndWidth: 4,
                        needleColor: Colors.grey.shade800,
                        knobStyle: KnobStyle(
                          knobRadius: 8,
                          sizeUnit: GaugeSizeUnit.logicalPixel,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${riskScore.toInt()}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: _zoneColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _zoneColor.withAlpha(30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _zoneLabel,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _zoneColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.85,
                      ),
                    ],
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
