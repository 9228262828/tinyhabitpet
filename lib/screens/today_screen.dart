import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../core/app_colors.dart';
import '../widgets/habit_tile.dart';
import '../widgets/pet_illustration.dart';
import '../widgets/reward_dialog.dart';
import '../widgets/section_header.dart';
import 'add_edit_habit_screen.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final habits = controller.habitsFor(today);
    final completed = controller.completedCountFor(today);
    final progress = habits.isEmpty ? 0.0 : completed / habits.length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Let’s grow together',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              const Icon(
                Icons.monetization_on_rounded,
                color: AppColors.gold,
              ),
              const SizedBox(width: 5),
              Text(
                '${controller.pet.coins}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  PetIllustration(
                    size: 210,
                    happiness: controller.pet.happiness,
                  ),
                  Text(
                    controller.pet.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'Level ${controller.pet.level} • '
                    '${controller.pet.stage}',
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: controller.pet.progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (controller.rewardAvailable)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.coral,
                ),
                title: const Text('Daily reward is ready'),
                subtitle: Text(
                  'Reward streak: ${controller.rewardStreak}/7',
                ),
                trailing: FilledButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => RewardDialog(
                        streak: controller.rewardStreak,
                        onClaim: controller.claimDailyReward,
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          const SizedBox(height: 16),
          SectionHeader(
            title: 'Today’s habits',
            action: IconButton.filledTonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditHabitScreen(
                      controller: controller,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: CircularProgressIndicator(value: progress),
              title: Text('$completed of ${habits.length} completed'),
              trailing: completed == habits.length && habits.isNotEmpty
                  ? const Icon(Icons.celebration_rounded)
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          if (habits.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Text(
                  'No habits scheduled today. Add a habit to begin.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...habits.map(
              (habit) => HabitTile(
                habit: habit,
                date: today,
                onTap: () =>
                    controller.toggleHabit(habit, today),
              ),
            ),
        ],
      ),
    );
  }
}
