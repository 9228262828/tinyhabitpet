import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../models/habit.dart';
import '../widgets/habit_tile.dart';
import 'add_edit_habit_screen.dart';
import 'archived_habits_screen.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final habits = controller.activeHabits;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'My Habits',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArchivedHabitsScreen(
                        controller: controller,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.archive_rounded),
              ),
              IconButton(
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
                icon: const Icon(Icons.add_circle_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (habits.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Text(
                  'No active habits yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...habits.map(
              (habit) => HabitTile(
                habit: habit,
                date: DateTime.now(),
                onTap: () => _openEditor(context, habit),
                onLongPress: () =>
                    controller.archiveHabit(habit),
              ),
            ),
        ],
      ),
    );
  }

  void _openEditor(BuildContext context, Habit habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditHabitScreen(
          controller: controller,
          habit: habit,
        ),
      ),
    );
  }
}
