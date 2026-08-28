import 'package:shared_preferences/shared_preferences.dart';

import '../feedback/app_feedback.dart';

/// Préférences utilisateur persistées (sons, vibrations, notifications).
abstract final class AppPreferences {
  static const _notifications = 'finedge.notifications';
  static const _sounds = 'finedge.sounds';
  static const _haptics = 'finedge.haptics';

  static bool notificationsEnabled = true;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled = prefs.getBool(_notifications) ?? true;
    AppFeedback.soundsEnabled = prefs.getBool(_sounds) ?? true;
    AppFeedback.hapticsEnabled = prefs.getBool(_haptics) ?? true;
  }

  static Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifications, value);
  }

  static Future<void> setSounds(bool value) async {
    AppFeedback.soundsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sounds, value);
  }

  static Future<void> setHaptics(bool value) async {
    AppFeedback.hapticsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_haptics, value);
  }
}
