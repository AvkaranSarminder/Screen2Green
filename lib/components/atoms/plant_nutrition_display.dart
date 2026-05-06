import 'package:flutter/material.dart';

class PlantNutritionDisplay extends StatelessWidget {
  const PlantNutritionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(32),
      ),
      height: 160,
      width: 300,
    );
  }
}
