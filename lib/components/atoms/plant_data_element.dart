import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PlantDataElement extends StatelessWidget {
  final IconData icon;
  final String label;
  final double percentage;

  const PlantDataElement({
    super.key,
    required this.icon,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LinearPercentIndicator(
            animation: true,
            animationDuration: 600,
            lineHeight: 8.0,
            percent: percentage,
            backgroundColor: colorScheme.surfaceContainerHigh,
            progressColor: Theme.of(context).primaryColor,
            barRadius: const Radius.circular(4),
            padding: EdgeInsets.zero,
            linearGradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
