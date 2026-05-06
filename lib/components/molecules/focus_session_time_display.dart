import 'package:flutter/material.dart';
import 'package:screen2green/helpers/painters.dart';

class FocusSessionTimeDisplay extends StatelessWidget {
  const FocusSessionTimeDisplay({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isActive,
  });

  final int totalSeconds;
  final int remainingSeconds;
  final bool isActive;

  String _formatTime() {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double progress = totalSeconds > 0
        ? (remainingSeconds / totalSeconds)
        : 0;

    return SizedBox(
      height: 280,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(280, 280),
            painter: RingPainter(
              progress: -progress,
              trackColor: colorScheme.surfaceContainerHighest,
              progressColor: colorScheme.primary,
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(),
                style: textTheme.displayLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 60,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isActive ? 'MINUTES LEFT' : 'MINUTES',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
