import 'dart:convert';
import '../models/habit.dart';
import '../models/pet_profile.dart';

class ExportService {
  const ExportService();

  String exportData({
    required List<Habit> habits,
    required PetProfile pet,
  }) {
    return const JsonEncoder.withIndent('  ').convert({
      'version': 1,
      'pet': pet.toJson(),
      'habits': habits.map((e) => e.toJson()).toList(),
    });
  }
}
