import 'package:flutter/material.dart';
import '../core/app_constants.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LegalPage(
      title: 'Privacy Policy',
      sections: [
        (
          'Overview',
          'Tiny Habit Pet is an offline habit-tracking application. It does not require registration, login, or a user account.',
        ),
        (
          'Information Collection',
          'The app does not collect, transmit, sell, rent, or share personal information.',
        ),
        (
          'Local Storage',
          'Habits, pet progress, coins, settings, achievements, and completion history are stored locally on your device using SharedPreferences.',
        ),
        (
          'Internet and Third Parties',
          'The app does not use Firebase, advertising SDKs, analytics services, cloud storage, or a backend server.',
        ),
        (
          'Your Choices',
          'You can remove all local information from Settings or by uninstalling the application.',
        ),
        (
          'Contact',
          'For privacy questions, contact US.',
        ),
      ],
    );
  }
}

class _LegalPage extends StatelessWidget {
  const _LegalPage({
    required this.title,
    required this.sections,
  });

  final String title;
  final List<(String, String)> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text('Last updated: July 25, 2026'),
          const SizedBox(height: 15),
          ...sections.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.$1,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(section.$2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
