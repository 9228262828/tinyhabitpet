import 'package:flutter/material.dart';
import '../core/app_constants.dart';

class RewardDialog extends StatelessWidget {
  const RewardDialog({
    super.key,
    required this.streak,
    required this.onClaim,
  });

  final int streak;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.card_giftcard_rounded, size: 48),
      title: const Text('Daily Reward'),
      content: Text(
        'Day ${streak + 1}\n'
        '+${AppConstants.dailyChestCoins} coins',
        textAlign: TextAlign.center,
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onClaim();
          },
          child: const Text('Claim reward'),
        ),
      ],
    );
  }
}
