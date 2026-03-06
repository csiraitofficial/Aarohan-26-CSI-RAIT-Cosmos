import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DisabilityType { none, deafMute, autistic, adhd, dyslexia }

class DisabilityProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_disability';

  DisabilityType _disability = DisabilityType.none;
  DisabilityType get disability => _disability;

  static const Map<DisabilityType, String> labels = {
    DisabilityType.none: 'None',
    DisabilityType.deafMute: 'Deaf-Mute',
    DisabilityType.autistic: 'Autistic',
    DisabilityType.adhd: 'ADHD',
    DisabilityType.dyslexia: 'Dyslexia',
  };

  Future<void> loadSavedDisability() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_prefKey);
    if (index != null && index < DisabilityType.values.length) {
      _disability = DisabilityType.values[index];
      notifyListeners();
    }
  }

  Future<void> setDisability(DisabilityType type) async {
    _disability = type;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, type.index);
  }
}
