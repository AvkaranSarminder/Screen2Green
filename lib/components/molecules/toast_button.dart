import 'package:flutter/material.dart';
import 'package:screen2green/components/atoms/my_special_button.dart';
import 'package:screen2green/components/atoms/my_toast_content.dart';

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
