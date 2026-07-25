import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../core/app_colors.dart';
import '../models/habit.dart';

class AddEditHabitScreen extends StatefulWidget {
  const AddEditHabitScreen({
    super.key,
    required this.controller,
    this.habit,
  });

  final AppController controller;
  final Habit? habit;

  @override
  State<AddEditHabitScreen> createState() =>
      _AddEditHabitScreenState();
}

class _AddEditHabitScreenState
    extends State<AddEditHabitScreen> {
  late final TextEditingController _titleController;
  late Set<int> _days;
  late IconData _icon;
  late Color _color;

  final _icons = const [
    Icons.water_drop_rounded,
    Icons.menu_book_rounded,
    Icons.directions_walk_rounded,
    Icons.fitness_center_rounded,
    Icons.self_improvement_rounded,
    Icons.bedtime_rounded,
    Icons.school_rounded,
    Icons.cleaning_services_rounded,
  ];

  final _colors = const [
    AppColors.green,
    AppColors.orange,
    AppColors.sky,
    AppColors.coral,
    AppColors.plum,
    AppColors.gold,
  ];

  @override
  void initState() {
    super.initState();
    final habit = widget.habit;
    _titleController =
        TextEditingController(text: habit?.title ?? '');
    _days = {...?habit?.daysOfWeek};
    if (_days.isEmpty) {
      _days = {1, 2, 3, 4, 5, 6, 7};
    }
    _icon = habit == null
        ? Icons.check_circle_rounded
        : IconData(
            habit.iconCodePoint,
            fontFamily: 'MaterialIcons',
          );
    _color =
        habit == null ? AppColors.green : Color(habit.colorValue);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty || _days.isEmpty) {
      return;
    }

    if (widget.habit == null) {
      await widget.controller.addHabit(
        title: _titleController.text,
        icon: _icon,
        color: _color,
        days: _days.toList()..sort(),
      );
    } else {
      await widget.controller.editHabit(
        habit: widget.habit!,
        title: _titleController.text,
        icon: _icon,
        color: _color,
        days: _days.toList()..sort(),
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.habit == null ? 'Add Habit' : 'Edit Habit',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Habit name',
              hintText: 'Example: Read for 10 minutes',
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Choose an icon',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _icons.map((icon) {
              final selected = icon == _icon;
              return IconButton.filledTonal(
                onPressed: () => setState(() => _icon = icon),
                icon: Icon(
                  icon,
                  color: selected ? _color : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          Text(
            'Choose a color',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            children: _colors.map((color) {
              return GestureDetector(
                onTap: () => setState(() => _color = color),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color == _color
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          Text(
            'Repeat on',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: List.generate(7, (index) {
              final day = index + 1;
              return ChoiceChip(
                label: Text(dayNames[index]),
                selected: _days.contains(day),
                onSelected: (_) {
                  setState(() {
                    _days.contains(day)
                        ? _days.remove(day)
                        : _days.add(day);
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 30),
          FilledButton(
            onPressed: _save,
            child: Text(
              widget.habit == null
                  ? 'Create habit'
                  : 'Save changes',
            ),
          ),
        ],
      ),
    );
  }
}
