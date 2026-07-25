import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../models/habit.dart';
import '../models/pet_profile.dart';

class LocalStorageService {
  late SharedPreferences _prefs;

  static const _habitsKey = 'habits_v2';
  static const _petKey = 'pet_v2';
  static const _settingsKey = 'settings_v2';
  static const _lastRewardKey = 'last_reward_date';
  static const _rewardStreakKey = 'reward_streak';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  List<Habit> loadHabits() {
    final raw = _prefs.getString(_habitsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => Habit.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHabits(List<Habit> habits) {
    return _prefs.setString(
      _habitsKey,
      jsonEncode(habits.map((e) => e.toJson()).toList()),
    );
  }

  PetProfile loadPet() {
    final raw = _prefs.getString(_petKey);
    if (raw == null || raw.isEmpty) return const PetProfile();
    try {
      return PetProfile.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw)),
      );
    } catch (_) {
      return const PetProfile();
    }
  }

  Future<void> savePet(PetProfile pet) {
    return _prefs.setString(_petKey, jsonEncode(pet.toJson()));
  }

  AppSettings loadSettings() {
    final raw = _prefs.getString(_settingsKey);
    if (raw == null || raw.isEmpty) return const AppSettings();
    try {
      return AppSettings.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw)),
      );
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) {
    return _prefs.setString(
      _settingsKey,
      jsonEncode(settings.toJson()),
    );
  }

  String? get lastRewardDate => _prefs.getString(_lastRewardKey);
  int get rewardStreak => _prefs.getInt(_rewardStreakKey) ?? 0;

  Future<void> saveRewardState({
    required String date,
    required int streak,
  }) async {
    await _prefs.setString(_lastRewardKey, date);
    await _prefs.setInt(_rewardStreakKey, streak);
  }

  Future<void> clearAll() => _prefs.clear();
}
