import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:screen2green/components/molecules/focus_session_controls.dart';
import 'package:screen2green/components/molecules/focus_session_time_display.dart';

class FocusView extends StatefulWidget {
  const FocusView({super.key, required this.onSessionStateChanged});

  final ValueChanged<bool> onSessionStateChanged;

  @override
  State<FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends State<FocusView>
    with SingleTickerProviderStateMixin {
  int _durationInMinutes = 25;
  late int _remainingSeconds = 1500;
  bool _isActive = false;
  Timer? _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  final String _generatedQuote =
      "Like your basil, you are growing in silence and strength.";

  void _startSession() {
    setState(() {
      _isActive = true;
      _remainingSeconds = _durationInMinutes * 60;
    });
    widget.onSessionStateChanged(true);
    _controller.forward();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 0) {
        _endSession();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _endSession() {
    _timer?.cancel();
    setState(() => _isActive = false);
    widget.onSessionStateChanged(false);
    _controller.reverse();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    setState(() => _remainingSeconds = _durationInMinutes * 60);
  }

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _durationInMinutes * 60;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _decrement() {
    if (_durationInMinutes > 5) {
      setState(() {
        _durationInMinutes -= 5;
        _remainingSeconds = _durationInMinutes * 60;
      });
    }
  }

  void _increment() {
    if (_durationInMinutes < 180) {
      setState(() {
        _durationInMinutes += 5;
        _remainingSeconds = _durationInMinutes * 60;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildIdleContent(context),
        FadeTransition(
          opacity: _animation,
          child: IgnorePointer(
            ignoring: !_isActive,
            child: _buildRunningOverlay(context),
          ),
        ),
      ],
    );
  }

  Widget _buildIdleContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Text(
              'Nurture Your Time',
              style: textTheme.displayLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Your seedling grows as you focus.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),

            FocusSessionTimeDisplay(
              totalSeconds: _durationInMinutes * 60,
              remainingSeconds: _remainingSeconds,
              isActive: false,
            ),
            const SizedBox(height: 32),
            FocusSessionControls(
              durationInMinutes: _durationInMinutes,
              onDecrement: _decrement,
              onIncrement: _increment,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _startSession,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Session'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: textTheme.titleLarge?.copyWith(fontSize: 18),
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunningOverlay(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            FocusSessionTimeDisplay(
              totalSeconds: _durationInMinutes * 60,
              remainingSeconds: _remainingSeconds,
              isActive: true,
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _generatedQuote,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(flex: 3),
            TextButton(
              onPressed: _endSession,
              child: Text(
                'End Session',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.25),
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
