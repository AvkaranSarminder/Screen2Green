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
          gradient: const LinearGradient(
            colors: [Color(0xFF50662B), Color(0xFFD2ECA2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF50662B).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F342E),
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward, color: Color(0xFF2F342E), size: 16),
          ],
        ),
      ),
    );
  }
}
