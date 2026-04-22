import 'package:flutter/material.dart';
import 'package:screen2green/views/home_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen2Green',
      theme: myAppTheme,
      home: const HomeView(),
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
    titleLarge: TextStyle(fontFamily: 'LeagueSpartan'),
    bodyLarge: TextStyle(fontFamily: 'UniverseCondensed'),
    bodyMedium: TextStyle(fontFamily: 'UniverseCondensed'),
  ),
);
