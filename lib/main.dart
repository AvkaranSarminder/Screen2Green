import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: ToastButton('Show Toast'))),
    );
  }
}

class MyToastContent extends StatelessWidget {
  const MyToastContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Hello! I am a simple toast! 🍞');
  }
}

class MySpecialButton extends StatelessWidget {
  const MySpecialButton(this.label, this.onPressed, {super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}

class ToastButton extends StatelessWidget {
  const ToastButton(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    // In Flutter, instead of using classic class inheritance (extends MySpecialButton),
    // we use "Composition". We simply return our original custom widget inside our build method!
    // This allows us to reuse the design of MySpecialButton, while giving our new widget 
    // a valid BuildContext to safely show the toast message!
    return MySpecialButton(
      label,
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: MyToastContent()),
        );
      },
    );
  }
}
