import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomBackground extends StatefulWidget {
  const CustomBackground({super.key});

  @override
  State<CustomBackground> createState() => _CustomBackgroundState();
}

class _CustomBackgroundState extends State<CustomBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Star properties
  final int _starCount = 40;
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);

    // Initialize stars with random positions and speeds
    final random = math.Random();
    _stars = List.generate(_starCount, (i) {
      return _Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: 0.2 + random.nextDouble() * 0.4,
        size: 1.5 + random.nextDouble() * 2.5,
        twinkle: random.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                ],
              ),
            ),
          ),

          // Animated floating shapes
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  // Stars or ice icons
                  if (_isDark)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _StarsPainter(
                          stars: _stars,
                          animationValue: _animation.value,
                        ),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _IceIconsPainter(
                          stars: _stars,
                          animationValue: _animation.value,
                        ),
                      ),
                    ),

                  // Large floating circle
                  Positioned(
                    top: 100 + math.sin(_animation.value) * 50,
                    right: 50 + math.cos(_animation.value * 0.8) * 30,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Medium floating shape
                  Positioned(
                    bottom: 200 + math.cos(_animation.value * 1.2) * 40,
                    left: 30 + math.sin(_animation.value * 0.6) * 25,
                    child: Transform.rotate(
                      angle: _animation.value * 0.5,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.15),
                              Theme.of(
                                context,
                              ).colorScheme.secondary.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Small floating triangle
                  Positioned(
                    top: 300 + math.sin(_animation.value * 1.5) * 30,
                    left: 100 + math.cos(_animation.value) * 20,
                    child: Transform.rotate(
                      angle: _animation.value,
                      child: CustomPaint(
                        size: const Size(80, 80),
                        painter: TrianglePainter(
                          color: Theme.of(
                            context,
                          ).colorScheme.tertiary.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),

                  // Another floating circle
                  Positioned(
                    bottom: 100 + math.sin(_animation.value * 0.7) * 35,
                    right: 150 + math.cos(_animation.value * 1.3) * 40,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.tertiary.withOpacity(0.15),
                            Theme.of(
                              context,
                            ).colorScheme.tertiary.withOpacity(0.03),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Hexagon shape
                  Positioned(
                    top: 500 + math.cos(_animation.value * 0.9) * 25,
                    right: 80 + math.sin(_animation.value * 1.1) * 30,
                    child: Transform.rotate(
                      angle: _animation.value * 0.3,
                      child: CustomPaint(
                        size: const Size(100, 100),
                        painter: HexagonPainter(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.08),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Star {
  double x;
  double y;
  double speed;
  double size;
  double twinkle;

  _Star({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.twinkle,
  });
}

class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;

  _StarsPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final star in stars) {
      // Move star horizontally, wrap around
      final dx = (star.x + (star.speed * animationValue / (2 * math.pi))) % 1.0;
      final dy = (star.y + (star.speed * animationValue / (4 * math.pi))) % 1.0;

      // Twinkle effect
      final twinkle =
          0.7 + 0.3 * math.sin(animationValue * 2 + star.twinkle * math.pi * 2);

      paint.color = Colors.white.withOpacity(0.7 * twinkle);

      final px = dx * size.width;
      final py = dy * size.height;

      _drawStar(canvas, px, py, star.size * twinkle, paint);
    }
  }

  void _drawStar(
    Canvas canvas,
    double x,
    double y,
    double radius,
    Paint paint,
  ) {
    final path = Path();
    const points = 5;
    for (int i = 0; i < points * 2; i++) {
      final angle = (math.pi / points) * i;
      final r = i.isEven ? radius : radius / 2.5;
      final px = x + r * math.cos(angle - math.pi / 2);
      final py = y + r * math.sin(angle - math.pi / 2);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) => true;
}

class _IceIconsPainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;

  _IceIconsPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.blue.withOpacity(0.18);

    for (final star in stars) {
      // Move icon horizontally, wrap around
      final dx = (star.x + (star.speed * animationValue / (2 * math.pi))) % 1.0;
      final dy = (star.y + (star.speed * animationValue / (4 * math.pi))) % 1.0;

      final px = dx * size.width;
      final py = dy * size.height;

      _drawIce(canvas, px, py, star.size * 2.2, paint);
    }
  }

  void _drawIce(Canvas canvas, double x, double y, double size, Paint paint) {
    // Simple snowflake/ice icon
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final x2 = x + size * math.cos(angle);
      final y2 = y + size * math.sin(angle);
      canvas.drawLine(Offset(x, y), Offset(x2, y2), paint);

      // Small branches
      final branchAngle1 = angle + math.pi / 12;
      final branchAngle2 = angle - math.pi / 12;
      final branchLen = size * 0.4;
      canvas.drawLine(
        Offset(
          x + size * 0.6 * math.cos(angle),
          y + size * 0.6 * math.sin(angle),
        ),
        Offset(
          x + size * 0.6 * math.cos(branchAngle1),
          y + size * 0.6 * math.sin(branchAngle1),
        ),
        paint,
      );
      canvas.drawLine(
        Offset(
          x + size * 0.6 * math.cos(angle),
          y + size * 0.6 * math.sin(angle),
        ),
        Offset(
          x + size * 0.6 * math.cos(branchAngle2),
          y + size * 0.6 * math.sin(branchAngle2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _IceIconsPainter oldDelegate) => true;
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonPainter extends CustomPainter {
  final Color color;

  HexagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);

    final firstControlPoint = Offset(size.width * 0.25, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.6);
    final secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ConnectedDiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Create a diamond shape with rounded corners that connects smoothly
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // Top point
    path.moveTo(centerX, centerY - radius);

    // Top-right curve
    path.arcToPoint(
      Offset(centerX + radius, centerY),
      radius: Radius.circular(radius * 0.3),
      clockwise: true,
    );

    // Bottom-right curve
    path.arcToPoint(
      Offset(centerX, centerY + radius),
      radius: Radius.circular(radius * 0.3),
      clockwise: true,
    );

    // Bottom-left curve
    path.arcToPoint(
      Offset(centerX - radius, centerY),
      radius: Radius.circular(radius * 0.3),
      clockwise: true,
    );

    // Top-left curve back to start
    path.arcToPoint(
      Offset(centerX, centerY - radius),
      radius: Radius.circular(radius * 0.3),
      clockwise: true,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CurvedTitleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.lineTo(0, size.height * 0.7);

    // Smooth curve towards the bottom middle
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.85,
    );

    // Another smooth curve towards bottom-right
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.9,
    );

    // Go up to top-right
    path.lineTo(size.width, 0);

    // Close the shape
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
