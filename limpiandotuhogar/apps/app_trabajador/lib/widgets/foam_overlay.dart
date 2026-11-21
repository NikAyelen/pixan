import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FoamOverlay extends StatefulWidget {
  final int count;
  const FoamOverlay({super.key, this.count = 34});

  @override
  State<FoamOverlay> createState() => _FoamOverlayState();
}

class _Foam {
  final double x;
  final double radius;
  final int speed;
  final double phase;
  final double sway;
  final double swayFreq;
  final double opacity;

  _Foam(math.Random r)
      : x = r.nextDouble(),
        radius = 2 + math.pow(r.nextDouble(), 2.2) * 9,
        speed = 1 + r.nextInt(2),
        phase = r.nextDouble(),
        sway = 4 + r.nextDouble() * 10,
        swayFreq = 1 + r.nextInt(3).toDouble(),
        opacity = 0.45 + r.nextDouble() * 0.55;
}

class _FoamOverlayState extends State<FoamOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Foam> _foam;

  @override
  void initState() {
    super.initState();
    final random = math.Random(11);
    _foam = List.generate(widget.count, (_) => _Foam(random));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          painter: _FoamPainter(_foam, _controller.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _FoamPainter extends CustomPainter {
  final List<_Foam> foam;
  final double t;

  _FoamPainter(this.foam, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final shine = Paint()..style = PaintingStyle.fill;

    final travel = size.height * 0.8;

    for (final b in foam) {
      final p = (t * b.speed + b.phase) % 1.0;
      final fadeIn = (p * 8).clamp(0.0, 1.0);
      final fadeOut = math.pow(1 - p, 0.8).toDouble();
      final a = fadeIn * fadeOut * b.opacity;

      final y = size.height + b.radius - p * travel;
      final x = b.x * size.width +
          math.sin(p * 2 * math.pi * b.swayFreq + b.phase * 8) * b.sway;
      final c = Offset(x, y);

      fill.color = Colors.white.withValues(alpha: 0.22 * a);
      edge.color = AppColors.waveMid.withValues(alpha: 0.45 * a);
      shine.color = Colors.white.withValues(alpha: 0.85 * a);

      canvas.drawCircle(c, b.radius, fill);
      canvas.drawCircle(c, b.radius, edge);
      if (b.radius > 4) {
        canvas.drawCircle(
          c + Offset(-b.radius * 0.35, -b.radius * 0.35),
          b.radius * 0.2,
          shine,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FoamPainter old) => old.t != t;
}