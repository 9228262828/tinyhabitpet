import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.date,
    required this.onTap,
    this.onLongPress,
  });

  final Habit habit;
  final DateTime date;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final completed = habit.isCompletedOn(date);
    final color = Color(habit.colorValue);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .16),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            IconData(
              habit.iconCodePoint,
              fontFamily: 'MaterialIcons',
            ),
            color: color,
          ),
        ),
        title: Text(
          habit.title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            decoration:
                completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${habit.currentStreak} day streak'),
        trailing: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed ? color : Colors.transparent,
            border: Border.all(color: color, width: 2),
          ),
          child: completed
              ? const Icon(Icons.check_rounded, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}
