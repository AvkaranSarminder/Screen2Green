import 'package:flutter/material.dart';

class MyToastContent extends StatelessWidget {
  const MyToastContent(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}
