import 'package:flutter/material.dart';

class MySpecialButton extends StatelessWidget {
  const MySpecialButton(
    this.label,
    this.onPressed, {
    super.key,
    this.gradient = false,
    this.icon,
    this.danger = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool gradient;
  final bool danger;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    if (danger) {
      return GestureDetector(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 140),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.error,
                  const Color.fromARGB(255, 233, 112, 112),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                if (icon != null) ...[const SizedBox(width: 6), icon!],
              ],
            ),
          ),
        ),
      );
    }

    if (!gradient) {
      return GestureDetector(
        onTap: onPressed,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 140),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (icon != null) ...[const SizedBox(width: 6), icon!],
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 140),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              if (icon != null) ...[const SizedBox(width: 6), icon!],
            ],
          ),
        ),
      ),
    );
  }
}
