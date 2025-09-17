import 'package:flutter/material.dart';

class CustomShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // ..color = Colors.white
      ..style = PaintingStyle.stroke;

    const double cornerRadius = 16.0;
    const double notchWidth = 100.0;
    const double notchDepth = 40.0;

    final path = Path();

    // Start at top-left
    path.moveTo(0, cornerRadius);

    // TOP-LEFT corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // TOP edge
    path.lineTo(size.width - cornerRadius, 0);

    // TOP-RIGHT corner
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // RIGHT edge down to top of notch
    path.lineTo(size.width, size.height - notchDepth - cornerRadius);

    // Curve into notch (right side)
    path.quadraticBezierTo(
      size.width,
      size.height - notchDepth,
      size.width - cornerRadius,
      size.height - notchDepth,
    );

    // Flat top of notch
    path.lineTo(size.width - notchWidth, size.height - notchDepth);

    // --- UPDATED: Even Smoother Sweeping Curve ---

    // You can adjust this value to change the curve's shape.
    // A larger number makes the curve wider and more gentle.
    const double smoothnessFactor = 2.0;

    // The total horizontal distance the curve will span.
    final double curveWidth = notchDepth * smoothnessFactor;

    // Define the start and end points for our wider S-curve.
    final Offset curveStart = Offset(
      size.width - notchWidth,
      size.height - notchDepth,
    );
    final Offset curveEnd = Offset(curveStart.dx - curveWidth, size.height);

    // The "handles" of the curve. Making them half the curve's width creates a very broad, gentle arc.
    final double handleOffset = curveWidth / 2;

    // Define the two control points that shape the curve.
    final Offset controlPoint1 = Offset(
      curveStart.dx - handleOffset,
      curveStart.dy,
    );
    final Offset controlPoint2 = Offset(
      curveEnd.dx + handleOffset,
      curveEnd.dy,
    );

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      curveEnd.dx,
      curveEnd.dy,
    );

    // --- End of Update ---

    // Continue along the bottom edge to the left
    path.lineTo(cornerRadius, size.height);

    // BOTTOM-LEFT corner
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // LEFT edge
    path.lineTo(0, cornerRadius);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
