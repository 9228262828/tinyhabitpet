import 'package:flutter/services.dart';

class HapticService {
  const HapticService();

  Future<void> selection(bool enabled) async {
    if (enabled) await HapticFeedback.selectionClick();
  }

  Future<void> success(bool enabled) async {
    if (enabled) await HapticFeedback.mediumImpact();
  }

  Future<void> heavy(bool enabled) async {
    if (enabled) await HapticFeedback.heavyImpact();
  }
}
