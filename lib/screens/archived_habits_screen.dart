import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';

class ArchivedHabitsScreen extends StatelessWidget {
  const ArchivedHabitsScreen({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final archived =
        controller.habits.where((habit) => habit.archived).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Archived Habits')),
      body: archived.isEmpty
          ? const Center(child: Text('No archived habits.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: archived.length,
              itemBuilder: (context, index) {
                final habit = archived[index];
                return Card(
                  child: ListTile(
                    title: Text(habit.title),
                    subtitle:
                        Text('${habit.totalCompletions} completions'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'restore') {
                          controller.restoreHabit(habit);
                        } else {
                          controller.deleteHabit(habit);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'restore',
                          child: Text('Restore'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete permanently'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
