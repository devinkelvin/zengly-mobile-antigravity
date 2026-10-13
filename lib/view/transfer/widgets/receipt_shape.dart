import 'package:flutter/material.dart';

class ReceiptShape extends StatelessWidget {
  const ReceiptShape({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 2,
          child: CustomPaint(
            size: Size(constraints.maxWidth, 540),
            painter: ReceiptShapePainter(
              context: context,
              color:
                  Theme.of(context).colorScheme.onPrimary, // Listen to theme
            ),
          ),
        );
      },
    );
  }
}

class ReceiptShapePainter extends CustomPainter {
  final Color? color;
  final BuildContext context;
  final double topBumpRadius;
  final double sideCutRadius;
  final double bottomCutRadius;

  ReceiptShapePainter({
    this.color,
    required this.context,
    this.topBumpRadius = 28,
    this.sideCutRadius = 9,
    this.bottomCutRadius = 9,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color ?? Colors.black
          ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;

    final path = Path();

    // ==== Start from top left corner ====
    path.moveTo(0, topBumpRadius + 12); // leave room for top corners

    // ==== Top-left corner ====
    path.quadraticBezierTo(0, topBumpRadius, 12, topBumpRadius);

    // ==== Top bump (outward) ====
    // path.lineTo((width / 2) - topBumpRadius, topBumpRadius);
    // path.arcToPoint(
    //   Offset((width / 2) + topBumpRadius, topBumpRadius),
    //   radius: Radius.circular(topBumpRadius),
    //   clockwise: true,
    // );

    

    // ==== Top inward cuts ====
    final double topSpacing = 3;
    final double topDiameter = bottomCutRadius * 2;
    final double topUnit = topDiameter + topSpacing;
    final double topAvailableWidth = width - 24;
    int topCount = ((topAvailableWidth - topSpacing) / topUnit).floor();
    double topUsedWidth = topCount * topUnit;
    double topStartX = 12 + (topAvailableWidth - topUsedWidth + topSpacing) / 2;

    path.lineTo(topStartX, topBumpRadius);

    for (int i = 0; i < topCount; i++) {
      final dx = topStartX + i * topUnit;
      path.arcToPoint(
        Offset(dx + topUnit, topBumpRadius),
        radius: Radius.circular(bottomCutRadius),
        clockwise: false,
      );
      path.lineTo(dx + topUnit + 0.5, topBumpRadius);
    }

    // ==== Top-right corner ====
    path.lineTo(width - 12, topBumpRadius);
    path.quadraticBezierTo(width, topBumpRadius, width, topBumpRadius + 12);

    // ==== Right-side inward cut (middle) ====
    // final double rightCutCenterY = height / 2.5;
    // path.lineTo(width, rightCutCenterY - sideCutRadius);
    // path.arcToPoint(
    //   Offset(width, rightCutCenterY + sideCutRadius),
    //   radius: Radius.circular(sideCutRadius),
    //   clockwise: false,
    // );

    // path.lineTo(width, height);

    // ==== Bottom inward cuts ====
    final double spacing = 3;
    final double diameter = bottomCutRadius * 2;
    final double unit = diameter + spacing;

    int count = ((width - spacing) / unit).floor();
    double usedWidth = count * unit;
    double startX = (width - usedWidth + spacing) / 2;

    path.lineTo(width, height);
    path.lineTo(startX + count * unit, height);

    for (int i = count - 1; i >= 0; i--) {
      final dx = startX + i * unit;
      path.arcToPoint(
        Offset(dx, height),
        radius: Radius.circular(bottomCutRadius),
        clockwise: false,
      );
      path.lineTo(dx + 0.5, height);
    }

    path.lineTo(0, height);

    // ==== Left-side inward cut (middle) ====
    // path.lineTo(0, rightCutCenterY + sideCutRadius);
    // path.arcToPoint(
    //   Offset(0, rightCutCenterY - sideCutRadius),
    //   radius: Radius.circular(sideCutRadius),
    //   clockwise: false,
    // );

    path.close();
    canvas.drawShadow(path, Colors.black, 8, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ReceiptShapePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.topBumpRadius != topBumpRadius ||
        oldDelegate.sideCutRadius != sideCutRadius ||
        oldDelegate.bottomCutRadius != bottomCutRadius;
  }
}
