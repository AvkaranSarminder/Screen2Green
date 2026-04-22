import 'package:flutter/material.dart';

class MySpecialButton extends StatelessWidget {
  const MySpecialButton(this.label, this.onPressed, {super.key});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
