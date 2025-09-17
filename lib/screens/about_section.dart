import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 20 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'نبذة عني',
            style: TextStyle(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jazeera',
            ),
          ),
          SizedBox(height: isMobile ? 20 : 30),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 30),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Text(
                'أنا مطور Flutter شغوف لدي خبرة في إنشاء تطبيقات موبايل جميلة وعالية الأداء. أحب العمل مع الحركات المخصصة وتصميم واجهات المستخدم المعقدة وتقديم تجارب استخدام استثنائية.',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  height: 1.7,
                  fontFamily: 'Jannat',
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.85),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
