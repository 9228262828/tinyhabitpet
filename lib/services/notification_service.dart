class NotificationService {
  const NotificationService();

  Future<void> initialize() async {}

  Future<void> scheduleHabitReminder({
    required String id,
    required String title,
  }) async {}

  Future<void> cancelHabitReminder(String id) async {}
}
