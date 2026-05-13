import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FocusSession {
  final DateTime date;
  final int durationSeconds;

  FocusSession({required this.date, required this.durationSeconds});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'duration': durationSeconds,
  };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
    date: DateTime.parse(json['date']),
    durationSeconds: json['duration'],
  );
}

class SessionStorage {
  static const _key = 's2g_sessions';

  static Future<List<FocusSession>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => FocusSession.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> save(FocusSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(session.toJson()));
    await prefs.setStringList(_key, raw);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
