import 'package:flutter/material.dart';
import 'package:screen2green/components/molecules/plant_data_overview.dart';

class MyPlantView extends StatefulWidget {
  const MyPlantView({super.key});

  @override
  State<MyPlantView> createState() => _MyPlantViewState();
}

class _MyPlantViewState extends State<MyPlantView> {
  bool userHasPlant = false;
  final String deviceId = 'some-random-id-for-testing';
  late final Stream<Map<String, dynamic>> dataStream;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: userHasPlant ? _buildPlantDashboard() : _buildScanner(),
    );
  }

  Widget _buildScanner() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Icon(Icons.qr_code_scanner, size: 100, color: colorScheme.secondary),
          const SizedBox(height: 24),
          const Text(
            "Connect to your Plant",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            "Scan the QR code on your plant pot to begin.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => setState(() => userHasPlant = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Scan QR Code",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => _showManualEntryDialog(),
            child: Text(
              "Or enter code manually",
              style: TextStyle(color: colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantDashboard() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your Basil',
            style: textTheme.displayLarge?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/dummy_plant.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const PlantDataDisplay(),
        ],
      ),
    );
  }

  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Plant Code"),
        content: const TextField(
          decoration: InputDecoration(hintText: "e.g. PX-2024"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() => userHasPlant = true);
              Navigator.pop(context);
            },
            child: const Text("Connect"),
          ),
        ],
      ),
    );
  }
}
