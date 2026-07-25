import 'package:flutter/material.dart';
import 'app.dart';
import 'controllers/app_controller.dart';
import 'services/local_storage_service.dart';
import 'services/sound_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalStorageService();
  await storage.initialize();

  final soundService = SoundService();
  await soundService.initialize();

  final controller = AppController(
    storage: storage,
    soundService: soundService,
  );
  await controller.initialize();

  runApp(TinyHabitPetApp(controller: controller));
}
