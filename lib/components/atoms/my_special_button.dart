import 'package:flutter/material.dart';

class MySpecialButton extends StatelessWidget {
  const MySpecialButton(
    this.label,
    this.onPressed, {
    super.key,
    this.gradient = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    if (!gradient) {
      return ElevatedButton(onPressed: onPressed, child: Text(label));
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward, size: 16),
          ],
        ),
      ),
    );
  }
}
