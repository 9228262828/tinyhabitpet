class DailyReward {
  const DailyReward({
    required this.day,
    required this.coins,
    required this.claimed,
  });

  final int day;
  final int coins;
  final bool claimed;
}
