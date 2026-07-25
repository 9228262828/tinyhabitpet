import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../core/app_colors.dart';
import '../widgets/stat_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final habits = controller.habitsFor(today);
    final completed = controller.completedCountFor(today);
    final percent = habits.isEmpty
        ? 0
        : ((completed / habits.length) * 100).round();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Statistics',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          StatCard(
            icon: Icons.check_circle_rounded,
            title: 'Total completions',
            value: '${controller.totalCompletions}',
            color: AppColors.green,
          ),
          StatCard(
            icon: Icons.local_fire_department_rounded,
            title: 'Best streak',
            value: '${controller.bestStreak} days',
            color: AppColors.orange,
          ),
          StatCard(
            icon: Icons.today_rounded,
            title: 'Today',
            value: '$percent%',
            color: AppColors.sky,
          ),
          StatCard(
            icon: Icons.stars_rounded,
            title: 'Pet level',
            value: '${controller.pet.level}',
            color: AppColors.gold,
          ),
          const SizedBox(height: 12),
          Text(
            'Habit progress',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ...controller.activeHabits.map(
            (habit) => Card(
              child: ListTile(
                title: Text(habit.title),
                subtitle:
                    Text('${habit.totalCompletions} completions'),
                trailing: Text(
                  '${habit.currentStreak}🔥',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
