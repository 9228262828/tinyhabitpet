import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../core/date_utils.dart';
import '../models/achievement.dart';
import '../models/app_settings.dart';
import '../models/habit.dart';
import '../models/pet_profile.dart';
import '../services/haptic_service.dart';
import '../services/local_storage_service.dart';
import '../services/sound_service.dart';

class AppController extends ChangeNotifier {
  AppController({
    required this.storage,
    required this.soundService,
  });

  final LocalStorageService storage;
  final SoundService soundService;
  final HapticService haptics = const HapticService();

  List<Habit> habits = [];
  PetProfile pet = const PetProfile();
  AppSettings settings = const AppSettings();

  bool rewardAvailable = false;
  int rewardStreak = 0;

  Future<void> initialize() async {
    habits = storage.loadHabits();
    pet = storage.loadPet();
    settings = storage.loadSettings();
    rewardStreak = storage.rewardStreak;

    soundService.setEnabled(settings.soundEnabled);

    if (habits.isEmpty) {
      habits = _starterHabits();
      await storage.saveHabits(habits);
    }

    _refreshRewardAvailability();
  }

  List<Habit> get activeHabits =>
      habits.where((habit) => !habit.archived).toList();

  List<Habit> habitsFor(DateTime date) =>
      activeHabits.where((habit) => habit.isScheduledFor(date)).toList();

  int completedCountFor(DateTime date) =>
      habitsFor(date).where((habit) => habit.isCompletedOn(date)).length;

  int get totalCompletions =>
      habits.fold(0, (sum, habit) => sum + habit.totalCompletions);

  int get bestStreak => habits.fold(
        0,
        (best, habit) =>
            habit.currentStreak > best ? habit.currentStreak : best,
      );

  List<Achievement> get achievements => const [
        Achievement(
          id: 'first_step',
          title: 'First Step',
          description: 'Complete your first habit.',
          target: 1,
          iconCodePoint: 0xe156,
        ),
        Achievement(
          id: 'ten_done',
          title: 'Getting Stronger',
          description: 'Complete 10 habits.',
          target: 10,
          iconCodePoint: 0xe7fd,
        ),
        Achievement(
          id: 'streak_7',
          title: 'One Week Wonder',
          description: 'Reach a 7-day streak.',
          target: 7,
          iconCodePoint: 0xef55,
        ),
      ];

  int progressForAchievement(Achievement achievement) {
    if (achievement.id == 'streak_7') return bestStreak;
    return totalCompletions;
  }

  Future<void> toggleHabit(Habit habit, DateTime date) async {
    final key = dateKey(date);
    final completed = [...habit.completedDates];
    final removing = completed.remove(key);

    if (!removing) {
      completed.add(key);
      pet = pet.reward(
        xpGain: AppConstants.rewardXp,
        coinGain: AppConstants.rewardCoins,
      );
      await storage.savePet(pet);
      await soundService.playSuccess();
      await haptics.success(settings.hapticsEnabled);
    } else {
      await soundService.playTap();
      await haptics.selection(settings.hapticsEnabled);
    }

    final index = habits.indexWhere((item) => item.id == habit.id);
    habits[index] = habit.copyWith(completedDates: completed);
    await storage.saveHabits(habits);
    notifyListeners();
  }

  Future<void> addHabit({
    required String title,
    required IconData icon,
    required Color color,
    required List<int> days,
  }) async {
    habits.add(
      Habit(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
        iconCodePoint: icon.codePoint,
        colorValue: color.toARGB32(),
        daysOfWeek: days,
        createdAt: DateTime.now(),
      ),
    );
    await storage.saveHabits(habits);
    await soundService.playTap();
    await haptics.selection(settings.hapticsEnabled);
    notifyListeners();
  }

  Future<void> editHabit({
    required Habit habit,
    required String title,
    required IconData icon,
    required Color color,
    required List<int> days,
  }) async {
    final index = habits.indexWhere((item) => item.id == habit.id);
    habits[index] = habit.copyWith(
      title: title.trim(),
      iconCodePoint: icon.codePoint,
      colorValue: color.toARGB32(),
      daysOfWeek: days,
    );
    await storage.saveHabits(habits);
    notifyListeners();
  }

  Future<void> archiveHabit(Habit habit) async {
    final index = habits.indexWhere((item) => item.id == habit.id);
    habits[index] = habit.copyWith(archived: true);
    await storage.saveHabits(habits);
    notifyListeners();
  }

  Future<void> restoreHabit(Habit habit) async {
    final index = habits.indexWhere((item) => item.id == habit.id);
    habits[index] = habit.copyWith(archived: false);
    await storage.saveHabits(habits);
    notifyListeners();
  }

  Future<void> deleteHabit(Habit habit) async {
    habits.removeWhere((item) => item.id == habit.id);
    await storage.saveHabits(habits);
    notifyListeners();
  }

  Future<void> renamePet(String value) async {
    if (value.trim().isEmpty) return;
    pet = pet.copyWith(name: value.trim());
    await storage.savePet(pet);
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings value) async {
    settings = value;
    soundService.setEnabled(settings.soundEnabled);
    await storage.saveSettings(settings);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await updateSettings(
      settings.copyWith(onboardingCompleted: true),
    );
  }

  Future<void> claimDailyReward() async {
    if (!rewardAvailable) return;

    pet = pet.copyWith(
      coins: pet.coins + AppConstants.dailyChestCoins,
      happiness: (pet.happiness + 8).clamp(0, 100),
    );

    rewardStreak = rewardStreak >= 7 ? 1 : rewardStreak + 1;
    final today = dateKey(DateTime.now());

    await storage.savePet(pet);
    await storage.saveRewardState(
      date: today,
      streak: rewardStreak,
    );

    rewardAvailable = false;
    await soundService.playReward();
    await haptics.heavy(settings.hapticsEnabled);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await storage.clearAll();
    habits = _starterHabits();
    pet = const PetProfile();
    settings = const AppSettings(onboardingCompleted: true);
    rewardStreak = 0;
    rewardAvailable = true;

    await storage.saveHabits(habits);
    await storage.savePet(pet);
    await storage.saveSettings(settings);
    notifyListeners();
  }

  void _refreshRewardAvailability() {
    final last = storage.lastRewardDate;
    rewardAvailable = last != dateKey(DateTime.now());
  }

  List<Habit> _starterHabits() {
    return [
      Habit(
        id: 'starter_water',
        title: 'Drink water',
        iconCodePoint: Icons.water_drop_rounded.codePoint,
        colorValue: AppColors.sky.toARGB32(),
        daysOfWeek: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: DateTime.now(),
      ),
      Habit(
        id: 'starter_read',
        title: 'Read 10 minutes',
        iconCodePoint: Icons.menu_book_rounded.codePoint,
        colorValue: AppColors.orange.toARGB32(),
        daysOfWeek: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: DateTime.now(),
      ),
      Habit(
        id: 'starter_walk',
        title: 'Take a short walk',
        iconCodePoint: Icons.directions_walk_rounded.codePoint,
        colorValue: AppColors.green.toARGB32(),
        daysOfWeek: const [1, 2, 3, 4, 5, 6, 7],
        createdAt: DateTime.now(),
      ),
    ];
  }
}
