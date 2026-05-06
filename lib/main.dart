import 'package:flutter/material.dart';
import 'package:screen2green/views/auth_view.dart';
import 'package:screen2green/views/main_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xavxfqyjrouftkbujtxd.supabase.co',
    anonKey: 'sb_publishable_e9e1acoith7CtX5LF2d4zg_7iXSQSz4',
  );
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen2Green',
      theme: myAppTheme,
      home: supabase.auth.currentSession != null
          ? const MainView()
          : const AuthView(),
    );
  }
}

final ThemeData myAppTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFaac03e),
    primary: const Color(0xFFaac03e),
    secondary: const Color(0xFF637f30),
    tertiary: const Color(0xFF5f4228),
    surface: const Color(0xFFd9d8dd),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'LeagueSpartan',
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontFamily: 'LeagueSpartan',
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(fontFamily: 'LeagueSpartan'),
    bodyMedium: TextStyle(fontFamily: 'LeagueSpartan'),
  ),
);
