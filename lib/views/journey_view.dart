import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:screen2green/helpers/session_storage.dart';

class JourneyView extends StatefulWidget {
  const JourneyView({super.key});

  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView>
    with SingleTickerProviderStateMixin {
  List<FocusSession> _sessions = [];
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  static const int _dailyGoalSeconds = 7200;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _loadSessions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    final sessions = await SessionStorage.load();
    if (mounted) {
      setState(() {
        _sessions = sessions;
        _isLoading = false;
      });
      _controller.forward(from: 0);
    }
  }

  Future<void> _clearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Clear all sessions?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Your entire focus history will be removed. This cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await SessionStorage.clear();
      _loadSessions();
    }
  }

  // ── Computed stats ──────────────────────────────────────────────

  int get _totalSeconds =>
      _sessions.fold(0, (sum, s) => sum + s.durationSeconds);

  int get _todaySeconds {
    final today = _todayKey();
    return _sessions
        .where((s) => _dateKey(s.date) == today)
        .fold(0, (sum, s) => sum + s.durationSeconds);
  }

  int get _bestSession => _sessions.isEmpty
      ? 0
      : _sessions.map((s) => s.durationSeconds).reduce((a, b) => a > b ? a : b);

  int get _streak {
    if (_sessions.isEmpty) return 0;
    final days = _sessions.map((s) => _dateKey(s.date)).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    int streak = 0;
    String check = _todayKey();
    for (final day in days) {
      if (day == check) {
        streak++;
        final d = DateTime.parse(check).subtract(const Duration(days: 1));
        check = _dateKey(d);
      } else if (day.compareTo(check) < 0) {
        break;
      }
    }
    return streak;
  }

  double get _dailyProgress =>
      (_todaySeconds / _dailyGoalSeconds).clamp(0.0, 1.0);

  List<FocusSession> get _recentSessions =>
      [..._sessions].reversed.take(5).toList();

  String _todayKey() => _dateKey(DateTime.now());
  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ── Formatters ──────────────────────────────────────────────────

  String _fmtDuration(int secs) {
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  String _fmtHours(int secs) {
    if (secs >= 3600) return '${(secs / 3600).toStringAsFixed(1)}h';
    return '${(secs / 60).round()}m';
  }

  String _fmtDate(DateTime d) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }

  // ── Build ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.secondary,
          strokeWidth: 2,
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Text(
              'Your Journey',
              style: textTheme.displayLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                'Every minute of focus is a drop of water.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 36),

            // ── Progress ring ──
            _buildProgressRing(colorScheme, textTheme),
            const SizedBox(height: 32),

            // ── Stat cards ──
            _buildStatGrid(colorScheme, textTheme),
            const SizedBox(height: 32),

            // ── Recent sessions ──
            Text(
              'Recent sessions',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 12),
            _buildSessionList(colorScheme, textTheme),
            const SizedBox(height: 32),

            // ── Clear button ──
            if (_sessions.isNotEmpty)
              Center(
                child: TextButton(
                  onPressed: _clearData,
                  child: Text(
                    'Clear history',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Progress ring widget ────────────────────────────────────────

  Widget _buildProgressRing(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final progress = _dailyProgress * _animation.value;
          return Column(
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(180, 180),
                      painter: _RingPainter(
                        progress: progress,
                        trackColor: colorScheme.surfaceContainerHighest,
                        progressColor: colorScheme.secondary,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _fmtHours(_totalSeconds),
                          style: textTheme.displayLarge?.copyWith(
                            fontSize: 36,
                            color: colorScheme.onSurface,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'total focus',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Daily goal: ${(_dailyProgress * 100).round()}% of 2h',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Stat grid ───────────────────────────────────────────────────

  Widget _buildStatGrid(ColorScheme colorScheme, TextTheme textTheme) {
    final stats = [
      _StatItem(
        icon: Icons.local_fire_department_rounded,
        value: '$_streak',
        label: 'day streak',
      ),
      _StatItem(
        icon: Icons.bar_chart_rounded,
        value: '${_sessions.length}',
        label: 'sessions',
      ),
      _StatItem(
        icon: Icons.emoji_events_rounded,
        value: _bestSession > 0 ? _fmtDuration(_bestSession) : '—',
        label: 'best session',
      ),
      _StatItem(
        icon: Icons.today_rounded,
        value: _fmtDuration(_todaySeconds),
        label: 'today',
      ),
    ];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: List.generate(stats.length, (i) {
            final delay = (i * 0.1);
            final itemProgress = (((_animation.value - delay) / (1 - delay))
                .clamp(0.0, 1.0));
            return Opacity(
              opacity: itemProgress,
              child: Transform.translate(
                offset: Offset(0, 12 * (1 - itemProgress)),
                child: _buildStatCard(stats[i], colorScheme, textTheme),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildStatCard(
    _StatItem item,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(item.icon, size: 20, color: colorScheme.secondary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.value,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                item.label,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Session list ────────────────────────────────────────────────

  Widget _buildSessionList(ColorScheme colorScheme, TextTheme textTheme) {
    if (_sessions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.eco_rounded,
              size: 32,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 10),
            Text(
              'No sessions yet.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Start a focus session to see your growth.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(_recentSessions.length, (i) {
              final session = _recentSessions[i];
              final isLast = i == _recentSessions.length - 1;
              final delay = 0.3 + (i * 0.08);
              final itemProgress = ((_animation.value - delay) / (1 - delay))
                  .clamp(0.0, 1.0);

              return Opacity(
                opacity: itemProgress,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _fmtDate(session.date),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Text(
                            _fmtDuration(session.durationSeconds),
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: 36,
                        endIndent: 16,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// ── Ring painter ────────────────────────────────────────────────────

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 10;
    const strokeWidth = 12.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Track
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}

// ── Data class ──────────────────────────────────────────────────────

class _StatItem {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });
}
