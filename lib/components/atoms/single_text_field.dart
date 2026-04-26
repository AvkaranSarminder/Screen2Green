import 'package:flutter/material.dart';

class SingleTextField extends StatelessWidget {
  const SingleTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
      ),
      obscureText: obscureText,
    );
  }
}
