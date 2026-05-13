import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/plant_data_element.dart';
import 'package:screen2green/components/atoms/plant_nutrition_display.dart';

class PlantDataDisplay extends StatelessWidget {
  const PlantDataDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: const [
            PlantDataElement(
              icon: Icons.water_drop_outlined,
              label: "Water Level",
              percentage: 0.5,
            ),
            PlantDataElement(
              icon: Icons.wb_sunny_outlined,
              label: "Light Intensity",
              percentage: 0.6,
            ),
          ],
        ),
        const SizedBox(height: 16),
        const PlantNutritionDisplay(),
        const SizedBox(height: 16),
        // Harvest Estimate (Horizontal style)
        const PlantDataElement(
          label: "Estimated Harvest",
          icon: Icons.calendar_today,
        ),
      ],
    );
  }
}
