import '../core/date_utils.dart';

class Habit {
  Habit({
    required this.id,
    required this.title,
    required this.iconCodePoint,
    required this.colorValue,
    required this.daysOfWeek,
    required this.createdAt,
    this.completedDates = const [],
    this.archived = false,
  });

  final String id;
  final String title;
  final int iconCodePoint;
  final int colorValue;
  final List<int> daysOfWeek;
  final DateTime createdAt;
  final List<String> completedDates;
  final bool archived;

  bool isScheduledFor(DateTime date) =>
      daysOfWeek.contains(date.weekday);

  bool isCompletedOn(DateTime date) =>
      completedDates.contains(dateKey(date));

  int get totalCompletions => completedDates.length;

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    final completed = completedDates.toSet();
    var cursor = DateTime.now();
    var streak = 0;

    while (completed.contains(dateKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Habit copyWith({
    String? title,
    int? iconCodePoint,
    int? colorValue,
    List<int>? daysOfWeek,
    List<String>? completedDates,
    bool? archived,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      createdAt: createdAt,
      completedDates: completedDates ?? this.completedDates,
      archived: archived ?? this.archived,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'iconCodePoint': iconCodePoint,
        'colorValue': colorValue,
        'daysOfWeek': daysOfWeek,
        'createdAt': createdAt.toIso8601String(),
        'completedDates': completedDates,
        'archived': archived,
      };

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      iconCodePoint: json['iconCodePoint'] as int,
      colorValue: json['colorValue'] as int,
      daysOfWeek: List<int>.from(json['daysOfWeek'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedDates:
          List<String>.from(json['completedDates'] as List? ?? const []),
      archived: json['archived'] as bool? ?? false,
    );
  }
}
