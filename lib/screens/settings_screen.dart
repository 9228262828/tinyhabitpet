import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../core/app_constants.dart';
import '../models/app_settings.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final settings = controller.settings;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Settings',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark mode'),
                  secondary: const Icon(Icons.dark_mode_rounded),
                  value: settings.darkMode,
                  onChanged: (value) => _update(
                    settings.copyWith(darkMode: value),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Sound effects'),
                  secondary: const Icon(Icons.volume_up_rounded),
                  value: settings.soundEnabled,
                  onChanged: (value) => _update(
                    settings.copyWith(soundEnabled: value),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Haptic feedback'),
                  secondary: const Icon(Icons.vibration_rounded),
                  value: settings.hapticsEnabled,
                  onChanged: (value) => _update(
                    settings.copyWith(hapticsEnabled: value),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_rounded),
                  title: const Text('Privacy Policy'),
                  trailing:
                      const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description_rounded),
                  title: const Text('Terms & Conditions'),
                  trailing:
                      const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => _confirmReset(context),
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Reset all progress'),
          ),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              '${AppConstants.appName} • Version ${AppConstants.version}',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _update(AppSettings value) {
    controller.updateSettings(value);
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text(
          'This removes habits, levels, coins, rewards, and local progress.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.resetAll();
    }
  }
}
