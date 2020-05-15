import 'package:flutter/services.dart';

abstract class Effects {
  static void playHapticTap() {
    HapticFeedback.lightImpact();
  }

  static Future<void> playHapticSuccess() async {
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.mediumImpact();
  }

  static Future<void> playHapticFailure() async {
    await HapticFeedback.heavyImpact();
  }
}
