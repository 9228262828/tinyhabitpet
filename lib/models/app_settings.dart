class AppSettings {
  const AppSettings({
    this.darkMode = false,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.onboardingCompleted = false,
  });

  final bool darkMode;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final bool onboardingCompleted;

  AppSettings copyWith({
    bool? darkMode,
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      onboardingCompleted:
          onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'darkMode': darkMode,
        'soundEnabled': soundEnabled,
        'hapticsEnabled': hapticsEnabled,
        'onboardingCompleted': onboardingCompleted,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      darkMode: json['darkMode'] as bool? ?? false,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      onboardingCompleted:
          json['onboardingCompleted'] as bool? ?? false,
    );
  }
}
