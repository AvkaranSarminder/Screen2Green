import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/plant_data_element.dart';
import 'package:screen2green/components/atoms/plant_nutrition_display.dart';

class PlantDataDisplay extends StatelessWidget {
  const PlantDataDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PlantDataElement(
          icon: Icons.water_drop_outlined,
          label: "Water Level",
          percentage: 0.5,
        ),
        const SizedBox(height: 16),
        const PlantDataElement(
          icon: Icons.dew_point,
          label: "Soil Moisture Level",
          percentage: 0.5,
        ),
        const SizedBox(height: 16),
        const PlantNutritionDisplay(),
        const SizedBox(height: 16),
        // Harvest Estimate (Horizontal style)
        const PlantDataElement(
          label: "Estimated Harvest",
          icon: Icons.calendar_today,
          percentage: 0.9,
        ),
      ],
    );
  }
}
