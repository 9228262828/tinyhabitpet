import 'package:flutter/material.dart';
import '../core/app_constants.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TermsPage(
      sections: [
        (
          'Acceptance',
          'By using Tiny Habit Pet, you agree to these Terms & Conditions.',
        ),
        (
          'Purpose',
          'The application is provided as a personal habit-building and entertainment tool. It is not medical, psychological, or professional advice.',
        ),
        (
          'Local Data',
          'All progress is stored locally. Removing the app or clearing app data may permanently delete your information.',
        ),
        (
          'Availability',
          'The application is provided as available without guarantees that it will always be error-free or uninterrupted.',
        ),
        (
          'Acceptable Use',
          'You may not misuse, reverse engineer, redistribute, or attempt to damage the application.',
        ),
        (
          'Contact',
          'For support or legal questions, contact ${AppConstants.supportEmail}.',
        ),
      ],
    );
  }
}

class _TermsPage extends StatelessWidget {
  const _TermsPage({required this.sections});

  final List<(String, String)> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
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
