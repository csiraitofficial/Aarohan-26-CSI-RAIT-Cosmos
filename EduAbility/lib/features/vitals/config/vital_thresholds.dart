import 'package:flutter/material.dart';
import 'package:mobile/services/api_service.dart';

class ZoneRange {
  final double min;
  final double max;
  final Color color;
  final String label;
  const ZoneRange(this.min, this.max, this.color, this.label);
}

class VitalThresholds {
  static const _green = Color(0xFF4CAF50);
  static const _yellow = Color(0xFFFFC107);
  static const _red = Color(0xFFF44336);

  // ── Heart Rate ──
  static List<ZoneRange> heartRateZones() {
    final cats = ApiService.healthCategories;
    if (cats.contains('heart') || cats.contains('elderly')) {
      return [
        const ZoneRange(0, 50, _red, 'Low'),
        const ZoneRange(50, 60, _yellow, 'Below Normal'),
        const ZoneRange(60, 80, _green, 'Normal'),
        const ZoneRange(80, 100, _yellow, 'Elevated'),
        const ZoneRange(100, 200, _red, 'High'),
      ];
    }
    if (cats.contains('pregnancy')) {
      return [
        const ZoneRange(0, 50, _red, 'Low'),
        const ZoneRange(50, 60, _yellow, 'Below Normal'),
        const ZoneRange(60, 110, _green, 'Normal'),
        const ZoneRange(110, 130, _yellow, 'Elevated'),
        const ZoneRange(130, 200, _red, 'High'),
      ];
    }
    // General
    return [
      const ZoneRange(0, 50, _red, 'Low'),
      const ZoneRange(50, 60, _yellow, 'Below Normal'),
      const ZoneRange(60, 100, _green, 'Normal'),
      const ZoneRange(100, 120, _yellow, 'Elevated'),
      const ZoneRange(120, 200, _red, 'High'),
    ];
  }

  // ── Blood Pressure (systolic) ──
  static List<ZoneRange> bpSystolicZones() {
    final cats = ApiService.healthCategories;
    if (cats.contains('hypertension')) {
      return [
        const ZoneRange(0, 90, _red, 'Low'),
        const ZoneRange(90, 130, _green, 'Normal'),
        const ZoneRange(130, 150, _yellow, 'Elevated'),
        const ZoneRange(150, 250, _red, 'High'),
      ];
    }
    if (cats.contains('elderly')) {
      return [
        const ZoneRange(0, 90, _red, 'Low'),
        const ZoneRange(90, 140, _green, 'Normal'),
        const ZoneRange(140, 160, _yellow, 'Elevated'),
        const ZoneRange(160, 250, _red, 'High'),
      ];
    }
    return [
      const ZoneRange(0, 80, _red, 'Low'),
      const ZoneRange(80, 120, _green, 'Normal'),
      const ZoneRange(120, 140, _yellow, 'Elevated'),
      const ZoneRange(140, 250, _red, 'High'),
    ];
  }

  // ── Blood Glucose (mg/dL) ──
  static List<ZoneRange> glucoseZones() {
    final cats = ApiService.healthCategories;
    if (cats.contains('diabetes1') || cats.contains('diabetes2')) {
      return [
        const ZoneRange(0, 70, _red, 'Low'),
        const ZoneRange(70, 80, _yellow, 'Below Target'),
        const ZoneRange(80, 130, _green, 'Target'),
        const ZoneRange(130, 180, _yellow, 'Elevated'),
        const ZoneRange(180, 400, _red, 'High'),
      ];
    }
    return [
      const ZoneRange(0, 55, _red, 'Low'),
      const ZoneRange(55, 70, _yellow, 'Below Normal'),
      const ZoneRange(70, 100, _green, 'Normal'),
      const ZoneRange(100, 125, _yellow, 'Elevated'),
      const ZoneRange(125, 400, _red, 'High'),
    ];
  }

  // ── Activity Goals ──
  static const int stepsGreen = 8000;
  static const int stepsYellow = 4000;
  static const double caloriesGreen = 300;
  static const double caloriesYellow = 150;
  static const int activeMinGreen = 30;
  static const int activeMinYellow = 15;
  static const int sleepGreenMin = 420; // 7 hours
  static const int sleepYellowMin = 360; // 6 hours

  static Color getZoneColor(double value, List<ZoneRange> zones) {
    for (final z in zones) {
      if (value >= z.min && value < z.max) return z.color;
    }
    return _red;
  }

  static String getZoneLabel(double value, List<ZoneRange> zones) {
    for (final z in zones) {
      if (value >= z.min && value < z.max) return z.label;
    }
    return 'Unknown';
  }
}
