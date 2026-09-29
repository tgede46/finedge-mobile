import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/guest_session.dart';

abstract class SessionStore {
  Future<GuestSession?> load();
  Future<void> save(GuestSession session);
}

class MemorySessionStore implements SessionStore {
  MemorySessionStore([this._session]);

  GuestSession? _session;

  @override
  Future<GuestSession?> load() async => _session;

  @override
  Future<void> save(GuestSession session) async {
    _session = session;
  }
}

class SharedPreferencesSessionStore implements SessionStore {
  SharedPreferencesSessionStore({this._prefs});

  static const _key = 'finedge.guest_session';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _instance() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<GuestSession?> load() async {
    final prefs = await _instance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    return GuestSession.fromJson(Map<String, dynamic>.from(decoded));
  }

  @override
  Future<void> save(GuestSession session) async {
    final prefs = await _instance();
    await prefs.setString(_key, jsonEncode(session.toJson()));
  }
}
