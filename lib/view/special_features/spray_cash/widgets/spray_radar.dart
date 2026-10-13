import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/data.dart';
import '../../../view.dart';

class SprayRadar extends ConsumerStatefulWidget {
  const SprayRadar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SprayRadarState();
}

class _SprayRadarState extends ConsumerState<SprayRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return CustomPaint(
                  painter: RadarPainter(animationValue: _controller.value),
                  size: Size(300, 300),
                );
              },
            ),
          ),
          Image.asset(AppImages.radarGif, height: 80, width: 80),
          ..._buildDeviceWidgets(context: context, radius: 130),
        ],
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double animationValue;

  RadarPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radiusStep = size.width / 12;
    final paint =
        Paint()
          ..color = Color(0XFFCE722C).withValues(alpha: 0.5)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radiusStep * i * 2, paint);
    }

    final glowPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              Color(0XFFCE722C),
              Color(0XFFCE722C).withValues(alpha: 0.0),
            ],
            stops: [0.0, 1.0],
          ).createShader(Rect.fromCircle(center: center, radius: 30));
    canvas.drawCircle(center, 30, glowPaint);

    final sweepPaint =
        Paint()
          ..color = Color(0XFFCE722C).withValues(alpha: 0.1)
          ..strokeWidth = 2;

    final angle = 2 * pi * animationValue;
    final endPoint = Offset(
      center.dx + cos(angle) * size.width / 2,
      center.dy + sin(angle) * size.height / 2,
    );
    canvas.drawLine(center, endPoint, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

List<Widget> _buildDeviceWidgets({
  required BuildContext context,
  required double radius,
}) {
  final angleStep = 2 * pi / max(3, 1);

  return List.generate(3, (index) {
    final angle = angleStep * index;

    final dx = radius * cos(angle);
    final dy = radius * sin(angle);

    return Positioned(
      left: (MediaQuery.of(context).size.width / 2) + dx - 20,
      top: (MediaQuery.of(context).size.height / 2) + dy - 100,
      child: FoundDevice(),
    );
  });
}
