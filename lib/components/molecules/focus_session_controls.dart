import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/round_icon_button.dart';

class FocusSessionControls extends StatelessWidget {
  final int durationInMinutes;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const FocusSessionControls({
    super.key,
    required this.durationInMinutes,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundIconButton(icon: Icons.remove, onTap: onDecrement),
        const SizedBox(width: 32),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$durationInMinutes',
                style: textTheme.displayLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 36,
                ),
              ),
              TextSpan(
                text: ' mins',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        RoundIconButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}
