import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/plant_nutrition_display.dart';

class JourneyView extends StatelessWidget {
  const JourneyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: PlantNutritionDisplay(),
    );
  }
}
