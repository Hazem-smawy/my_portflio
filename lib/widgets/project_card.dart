import 'package:flutter/material.dart';
import 'package:my_portflio/models/project_model.dart';
import 'package:my_portflio/screens/product_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectDetailsPage(project: project),
          ),
        );
      },
      child: Center(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: SizedBox(
                height: 300,
                width: double.infinity, // adjust to your design
                child: ClipPath(
                  clipper: CustomCardClipper(),
                  child: CachedNetworkImage(
                    imageUrl: project.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 15,
              child: Text(
                project.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  // color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom clipper matching your CustomShapePainter
class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cornerRadius = 16.0;
    const double notchWidth = 100.0;
    const double notchDepth = 40.0;
    const double smoothnessFactor = 2.0;

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

    // Smooth sweeping curve into bottom
    final double curveWidth = notchDepth * smoothnessFactor;
    final Offset curveStart = Offset(
      size.width - notchWidth,
      size.height - notchDepth,
    );
    final Offset curveEnd = Offset(curveStart.dx - curveWidth, size.height);
    final double handleOffset = curveWidth / 2;
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

    // Bottom-left corner
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // LEFT edge
    path.lineTo(0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
