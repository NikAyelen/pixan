import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BubblesBackground extends StatefulWidget {
  final Widget child;
  final int count;

  const BubblesBackground({super.key, required this.child, this.count = 22});

  @override
  State<BubblesBackground> createState() => _BubblesBackgroundState();
}

class _Bubble {
  final double x;
  final double radius;
  final int speed;
  final double phase;
  final double sway;
  final double swayFreq;

  _Bubble(math.Random r)
      : x = r.nextDouble(),
        radius = 6 + r.nextDouble() * 26,
        speed = 1 + r.nextInt(3),
        phase = r.nextDouble(),
        sway = 8 + r.nextDouble() * 18,
        swayFreq = 1 + r.nextInt(3).toDouble();
}

class _BubblesBackgroundState extends State<BubblesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Bubble> _bubbles;

  @override
  void initState() {
    super.initState();
    final random = math.Random(7);
    _bubbles = List.generate(widget.count, (_) => _Bubble(random));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.background),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) => CustomPaint(
                    painter: _BubblesPainter(_bubbles, _controller.value),
                  ),
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _BubblesPainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final double t;

  _BubblesPainter(this.bubbles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final shine = Paint()..style = PaintingStyle.fill;

    for (final b in bubbles) {
      final progress = (t * b.speed + b.phase) % 1.0;
      final y = size.height + b.radius - progress * (size.height + b.radius * 2);
      final x = b.x * size.width +
          math.sin(progress * 2 * math.pi * b.swayFreq + b.phase * 10) * b.sway;
      final center = Offset(x, y);

      fill.color = Colors.white.withValues(alpha: 0.16);
      stroke.color = Colors.white.withValues(alpha: 0.55);
      shine.color = Colors.white.withValues(alpha: 0.7);

      canvas.drawCircle(center, b.radius, fill);
      canvas.drawCircle(center, b.radius, stroke);
      canvas.drawCircle(
        center + Offset(-b.radius * 0.35, -b.radius * 0.35),
        b.radius * 0.18,
        shine,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubblesPainter old) => old.t != t;
}