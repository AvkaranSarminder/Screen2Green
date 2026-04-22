import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: ToastButton('Show Toast')),
        appBar: AppBar(
          title: Image.asset(
            'assets/images/tempor-removebg-preview.png',
            height: 61,
          ),
        ),
      ),
    );
  }
}

class MyToastContent extends StatelessWidget {
  const MyToastContent(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label);
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
    return MySpecialButton(label, () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: MyToastContent('Yoooo button pressed here!')),
      );
    });
  }
}

class MySpecialTextField extends StatelessWidget {
  MySpecialTextField({super.key, required this.handleSubmit});

  final void Function(String) handleSubmit;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
        labelText: 'Enter your firstname',
      ),
      controller: controller,
      onSubmitted: (text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: MyToastContent('Hello $text!')));
      },
    );
  }
}
