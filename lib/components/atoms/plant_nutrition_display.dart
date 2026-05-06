import 'package:flutter/material.dart';

class PlantNutritionDisplay extends StatelessWidget {
  const PlantNutritionDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: EdgeInsets.all(24),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: EdgeInsets.all(10),
            child: Icon(Icons.eco),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Nutritient Status', style: textTheme.titleLarge),
              Text('Last fed 5 days ago'),
            ],
          ),
          Text('Nutrition'),
        ],
      ),
    );
  }
}
