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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF0E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: percentage,
            animation: true,
            animationDuration: 1000,
            leading: Icon(icon, color: colorScheme.primary),
            trailing: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            progressColor: colorScheme.primary,
            backgroundColor: Colors.white,
            barRadius: const Radius.circular(10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
            selectionColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
