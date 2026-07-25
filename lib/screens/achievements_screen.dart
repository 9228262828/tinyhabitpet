import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({
    super.key,
    required this.controller,
  });

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.achievements;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final progress =
              controller.progressForAchievement(item);
          final unlocked = progress >= item.target;

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  unlocked
                      ? Icons.emoji_events_rounded
                      : Icons.lock_rounded,
                ),
              ),
              title: Text(item.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.description),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (progress / item.target).clamp(0, 1),
                  ),
                ],
              ),
              trailing: Text(
                '$progress/${item.target}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          );
        },
      ),
    );
  }
}
