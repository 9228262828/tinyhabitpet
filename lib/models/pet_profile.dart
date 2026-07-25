class PetProfile {
  const PetProfile({
    this.name = 'Milo',
    this.level = 1,
    this.xp = 0,
    this.coins = 0,
    this.energy = 60,
    this.happiness = 70,
    this.unlockedAccessories = const ['green_scarf'],
    this.equippedAccessory = 'green_scarf',
  });

  final String name;
  final int level;
  final int xp;
  final int coins;
  final int energy;
  final int happiness;
  final List<String> unlockedAccessories;
  final String equippedAccessory;

  int get xpTarget => 100 + ((level - 1) * 25);
  double get progress => (xp / xpTarget).clamp(0, 1);

  String get stage {
    if (level >= 25) return 'Legendary';
    if (level >= 15) return 'Adult';
    if (level >= 8) return 'Young';
    if (level >= 3) return 'Baby';
    return 'Hatchling';
  }

  PetProfile reward({
    required int xpGain,
    required int coinGain,
  }) {
    var nextXp = xp + xpGain;
    var nextLevel = level;

    while (nextXp >= 100 + ((nextLevel - 1) * 25)) {
      nextXp -= 100 + ((nextLevel - 1) * 25);
      nextLevel++;
    }

    return copyWith(
      level: nextLevel,
      xp: nextXp,
      coins: coins + coinGain,
      energy: (energy + 5).clamp(0, 100),
      happiness: (happiness + 4).clamp(0, 100),
    );
  }

  PetProfile copyWith({
    String? name,
    int? level,
    int? xp,
    int? coins,
    int? energy,
    int? happiness,
    List<String>? unlockedAccessories,
    String? equippedAccessory,
  }) {
    return PetProfile(
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      unlockedAccessories:
          unlockedAccessories ?? this.unlockedAccessories,
      equippedAccessory:
          equippedAccessory ?? this.equippedAccessory,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'level': level,
        'xp': xp,
        'coins': coins,
        'energy': energy,
        'happiness': happiness,
        'unlockedAccessories': unlockedAccessories,
        'equippedAccessory': equippedAccessory,
      };

  factory PetProfile.fromJson(Map<String, dynamic> json) {
    return PetProfile(
      name: json['name'] as String? ?? 'Milo',
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      energy: json['energy'] as int? ?? 60,
      happiness: json['happiness'] as int? ?? 70,
      unlockedAccessories: List<String>.from(
        json['unlockedAccessories'] as List? ?? const ['green_scarf'],
      ),
      equippedAccessory:
          json['equippedAccessory'] as String? ?? 'green_scarf',
    );
  }
}
