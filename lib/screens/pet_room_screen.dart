import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../core/app_colors.dart';
import '../widgets/pet_illustration.dart';

class PetRoomScreen extends StatelessWidget {
  const PetRoomScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Pet Room',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Card(
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFE8BF),
                    Color(0xFFE8F0C4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: 26,
                    left: 24,
                    child: Icon(
                      Icons.eco_rounded,
                      size: 72,
                      color: AppColors.green,
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: Icon(
                      Icons.window_rounded,
                      size: 92,
                      color: Colors.lightBlue.shade200,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PetIllustration(
                      size: 270,
                      happiness: controller.pet.happiness,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatusCard(
                  title: 'Energy',
                  value: controller.pet.energy,
                  icon: Icons.bolt_rounded,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatusCard(
                  title: 'Happiness',
                  value: controller.pet.happiness,
                  icon: Icons.favorite_rounded,
                  color: AppColors.coral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: () => _rename(context),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Rename your pet'),
          ),
        ],
      ),
    );
  }

  Future<void> _rename(BuildContext context) async {
    final field =
        TextEditingController(text: controller.pet.name);

    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename pet'),
        content: TextField(
          controller: field,
          autofocus: true,
          maxLength: 18,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, field.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    field.dispose();
    if (name != null) {
      await controller.renamePet(name);
    }
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 7),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: value / 100,
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            const SizedBox(height: 6),
            Text('$value%'),
          ],
        ),
      ),
    );
  }
}
