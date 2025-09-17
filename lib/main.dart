import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:my_portflio/controller/theme_controller.dart';
import 'screens/portfolio_home.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(
      () => GetMaterialApp(
        title: 'Flutter Portfolio',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: themeController.currentColor.value,
          fontFamily: 'Jazeera',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeController.currentColor.value,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          primarySwatch: themeController.currentColor.value,
          fontFamily: 'Jazeera',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeController.currentColor.value,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: themeController.themeMode,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const PortfolioHome(),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: CustomShapeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class CustomShapePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     const double cornerRadius = 16.0;
//     const double notchWidth = 140.0;
//     const double notchDepth = 50.0;

//     final path = Path();

//     // Start at top-left
//     path.moveTo(0, cornerRadius);

//     // TOP-LEFT corner
//     path.quadraticBezierTo(0, 0, cornerRadius, 0);

//     // TOP edge
//     path.lineTo(size.width - cornerRadius, 0);

//     // TOP-RIGHT corner
//     path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

//     // RIGHT edge down to top of notch
//     path.lineTo(size.width, size.height - notchDepth - cornerRadius);

//     // Curve into notch (right side)
//     path.quadraticBezierTo(
//       size.width,
//       size.height - notchDepth,
//       size.width - cornerRadius,
//       size.height - notchDepth,
//     );

//     // Flat top of notch
//     path.lineTo(
//       size.width - notchWidth + cornerRadius,
//       size.height - notchDepth,
//     );

//     // Curve out of notch (left side)
//     path.quadraticBezierTo(
//       size.width - notchWidth,
//       size.height - notchDepth,
//       size.width - notchWidth - cornerRadius,
//       size.height - notchDepth,
//     );

//     // Smooth bottom curve toward bottom-left
//     path.quadraticBezierTo(
//       0, // control point x
//       size.height, // control point y
//       cornerRadius, // end x
//       size.height - cornerRadius / 2, // end y
//     );

//     // Left edge curve up (replace arcToPoint)
//     path.quadraticBezierTo(
//       0,
//       size.height, // control point
//       0,
//       size.height - cornerRadius, // end point
//     );

//     // Left edge
//     path.lineTo(0, cornerRadius);

//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// class CustomShapePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     const double cornerRadius = 16.0;
//     const double notchWidth = 100.0;
//     const double notchDepth = 50.0;

//     final path = Path();

//     // Start at top-left
//     path.moveTo(0, cornerRadius);

//     // TOP-LEFT corner
//     path.quadraticBezierTo(0, 0, cornerRadius, 0);

//     // TOP edge
//     path.lineTo(size.width - cornerRadius, 0);

//     // TOP-RIGHT corner
//     path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

//     // RIGHT edge down to top of notch
//     path.lineTo(size.width, size.height - notchDepth - cornerRadius);

//     // Curve into notch (right side)
//     path.quadraticBezierTo(
//       size.width,
//       size.height - notchDepth,
//       size.width - cornerRadius,
//       size.height - notchDepth,
//     );

//     // Flat top of notch
//     path.lineTo(size.width - notchWidth, size.height - notchDepth);

//     // --- NEW: Single Sweeping Curve ---
//     // This cubic curve creates a smooth "S" shape to connect the notch
//     // to the bottom edge seamlessly.

//     // Define the start and end points for our S-curve
//     final Offset curveStart = Offset(
//       size.width - notchWidth,
//       size.height - notchDepth,
//     );
//     final Offset curveEnd = Offset(
//       size.width - notchWidth - (notchDepth * 2),
//       size.height,
//     );

//     // Define the two control points that shape the curve
//     final Offset controlPoint1 = Offset(
//       curveStart.dx - (notchDepth * 0.7),
//       curveStart.dy,
//     );
//     final Offset controlPoint2 = Offset(
//       curveEnd.dx + (notchDepth * 0.7),
//       curveEnd.dy,
//     );

//     path.cubicTo(
//       controlPoint1.dx,
//       controlPoint1.dy,
//       controlPoint2.dx,
//       controlPoint2.dy,
//       curveEnd.dx,
//       curveEnd.dy,
//     );

//     // --- End of New Curve ---

//     // Continue along the bottom edge to the left
//     path.lineTo(cornerRadius, size.height);

//     // BOTTOM-LEFT corner
//     path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

//     // LEFT edge
//     path.lineTo(0, cornerRadius);

//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
