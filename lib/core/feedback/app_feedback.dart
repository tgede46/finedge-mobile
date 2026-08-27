import 'package:flutter/services.dart';

/// Haptics + sons système (MVP, sans assets audio).
class AppFeedback {
  AppFeedback._();

  static bool hapticsEnabled = true;
  static bool soundsEnabled = true;

  static Future<void> selection() async {
    if (hapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
    if (soundsEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  static Future<void> light() async {
    if (hapticsEnabled) {
      await HapticFeedback.lightImpact();
    }
    if (soundsEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  static Future<void> medium() async {
    if (hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
    if (soundsEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  static Future<void> success() async {
    if (hapticsEnabled) {
      await HapticFeedback.mediumImpact();
    }
    if (soundsEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }
}
