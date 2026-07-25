import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../widgets/pet_illustration.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final _items = const [
    (
      'Small steps every day',
      'Create simple habits and check them off when you finish.',
      Icons.check_circle_rounded,
    ),
    (
      'Help your pet grow',
      'Every completed habit gives your pet XP and coins.',
      Icons.pets_rounded,
    ),
    (
      'Build strong streaks',
      'Stay consistent, unlock achievements, and collect rewards.',
      Icons.local_fire_department_rounded,
    ),
  ];

  Future<void> _next() async {
    if (_page < _items.length - 1) {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    await widget.controller.completeOnboarding();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 26),
            const PetIllustration(size: 185),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _items.length,
                onPageChanged: (value) =>
                    setState(() => _page = value),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.$3, size: 54),
                        const SizedBox(height: 18),
                        Text(
                          item.$1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.$2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                onPressed: _next,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(
                  _page == _items.length - 1
                      ? 'Start growing'
                      : 'Continue',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
