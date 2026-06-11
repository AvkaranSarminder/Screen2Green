import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPlantView extends StatefulWidget {
  const MyPlantView({super.key});

  @override
  State<MyPlantView> createState() => _MyPlantViewState();
}

class _MyPlantViewState extends State<MyPlantView> {
  bool userHasPlant = false;

  late Future<dynamic> plantFuture;
  late Future<dynamic> testFuture;

  @override
  void initState() {
    super.initState();
  }

  void _refreshPlant() {
    final supabase = Supabase.instance.client;
    setState(() {
      plantFuture = supabase
          .from('plant_pots')
          .select('''
      id,
      moisture,
      temperature,
      water,
      water_pass_through,
      relay_command
    ''')
          .eq('device_id', "testforEPS26")
          .maybeSingle();
    });
  }

  void _testFetch() async {
    final supabase = Supabase.instance.client;

    try {
      final data = await supabase
          .from('plant_pots')
          .select()
          .order('created_at', ascending: false);

      debugPrint("TEST DATA: $data");

      setState(() {
        testFuture = Future.value(data);
      });
    } catch (e) {
      debugPrint("ERROR TEST: $e");
    }
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

    return FutureBuilder<dynamic>(
      future: plantFuture,
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

        final plant = snapshot.data;

        if (plant == null) {
          return const Center(child: Text("No plant found in database"));
        }

        debugPrint("PLANT DATA: $plant");

        final temperature = (plant['temperature']);

        final soilMoisture = (plant['moisture']);

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
              setState(() {
                userHasPlant = true;
              });
              _refreshPlant();
              _testFetch();
            },
            child: const Text("Scan QR Code"),
          ),
        ],
      ),
    );
  }
}
