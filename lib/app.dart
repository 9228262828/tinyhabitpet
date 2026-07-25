import 'package:flutter/material.dart';
import 'controllers/app_controller.dart';
import 'core/app_theme.dart';
import 'screens/splash_screen.dart';

class TinyHabitPetApp extends StatelessWidget {
  const TinyHabitPetApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tiny Habit Pet',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              controller.settings.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(controller: controller),
        );
      },
    );
  }
}
