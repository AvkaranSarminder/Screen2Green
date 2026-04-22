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
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeView(),
    );
  }
}
