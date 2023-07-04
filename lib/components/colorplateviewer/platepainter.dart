import 'package:flutter/material.dart';

class PlatePainter extends CustomPainter {
  const PlatePainter({required this.plate});

  final List<List<Color>> plate;

  final Offset startOffset = const Offset(20, 20);
  final double xStep = 25;
  final double yStep = 30;
  final double radius = 10;

  @override
  void paint(Canvas canvas, Size size) {
    double dy = startOffset.dy;
    double dx = startOffset.dx;

    for (List<Color> colors in plate) {
      for (Color c in colors) {
        Paint paint1 = Paint()
          ..color = c
          ..style = PaintingStyle.fill;

        Paint paint2 = Paint()
          ..color = Colors.white38
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;

        canvas.drawCircle(Offset(dx, dy), radius, paint1);
        canvas.drawCircle(Offset(dx, dy), radius, paint2);

        dx += xStep;
      }

      dx = startOffset.dx;
      dy += yStep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
