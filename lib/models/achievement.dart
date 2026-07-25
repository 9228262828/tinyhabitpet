class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.iconCodePoint,
  });

  final String id;
  final String title;
  final String description;
  final int target;
  final int iconCodePoint;
}
