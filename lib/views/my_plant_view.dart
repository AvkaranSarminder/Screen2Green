import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/my_special_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPlantView extends StatefulWidget {
  const MyPlantView({super.key});

  @override
  State<MyPlantView> createState() => _MyPlantViewState();
}

class _MyPlantViewState extends State<MyPlantView> {
  bool userHasPlant = false;
  Stream<List<Map<String, dynamic>>>? _plantStream;

  void _toggleValveState() async {
    final supabase = Supabase.instance.client;

    try {
      await supabase
          .from('plant_pots')
          .update({'water_pass_through': true})
          .eq('device_id', 'testforEPS26');
      debugPrint('Valve ON');

      await Future.delayed(const Duration(seconds: 4));
      await supabase
          .from('plant_pots')
          .update({'water_pass_through': false})
          .eq('device_id', 'testforEPS26');
      debugPrint('Valve OFF');
    } catch (e) {
      debugPrint('Error toggling valve: $e');
    }
  }

  void _startStream() {
    _plantStream = Supabase.instance.client
        .from('plant_pots')
        .stream(primaryKey: ['id'])
        .eq('device_id', 'testforEPS26')
        .map(
          (rows) => rows
              .map(
                (r) => {
                  'id': r['id'],
                  'moisture': r['moisture'],
                  'temperature': r['temperature'],
                  'water': r['water'],
                  'water_pass_through': r['water_pass_through'],
                  'relay_command': r['relay_command'],
                },
              )
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: userHasPlant ? _buildPlantDashboard() : _buildScanner(),
    );
  }

  Widget _buildPlantDashboard() {
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _plantStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(48),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final rows = snapshot.data;
        if (rows == null || rows.isEmpty) {
          return const Center(child: Text("No plant found in database"));
        }

        final plant = rows.first;
        debugPrint("PLANT DATA: $plant");

        final temperature = plant['temperature'];
        final soilMoisture = plant['moisture'];

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your Basil',
                style: textTheme.displayLarge?.copyWith(fontSize: 32),
              ),

              const SizedBox(height: 24),

              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Image.asset(
                  'assets/images/dummy_plant.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 24),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.thermostat),
                  title: const Text('Temperature'),
                  trailing: Text('$temperature °C'),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.water_drop),
                  title: const Text('Soil Moisture'),
                  trailing: Text('$soilMoisture'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: Center(
                  child: MySpecialButton(
                    'Water your plant',
                    _toggleValveState,
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    gradient: true,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScanner() {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
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
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              _startStream();
              setState(() {
                userHasPlant = true;
              });
            },
            child: const Text("Scan QR Code"),
          ),
        ],
      ),
    );
  }
}
