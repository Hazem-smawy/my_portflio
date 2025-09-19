import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class HeroSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final void Function(int) scrollToSection;

  const HeroSection({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.scrollToSection,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final imageUrl = '/my_photo/my_photo.jpg';

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile avatar with custom shape
              if (!isMobile) SizedBox(height: 100),
              Container(
                width: isMobile ? 150 : 180,
                height: isMobile ? 150 : 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Container(
                  width: 120,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    // : (context, child, loadingProgress) {
                    //   if (loadingProgress == null) return child;
                    //   return Center(
                    //     child: CircularProgressIndicator(
                    //       value: loadingProgress.expectedTotalBytes != null
                    //           ? loadingProgress.cumulativeBytesLoaded /
                    //                 loadingProgress.expectedTotalBytes!
                    //           : null,
                    //     ),
                    //   );
                    // },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.person_outline,
                          size: 80,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 30 : 40),
              // Name and title
              Text(
                'حازم السماوي',
                style: TextStyle(
                  fontSize: isMobile ? 32 : 42,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jazeera',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'أصنع تطبيقات مميزة تجمع بين الإبداع والتقنية.\nأؤمن أن التفاصيل تصنع الفرق.',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontFamily: 'Jannat',
                  height: 1.7,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 40 : 50),
              // CTA Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      scrollToSection(1);
                    },
                    icon: Builder(
                      builder: (context) {
                        final color = Theme.of(context).colorScheme.primary;
                        return SvgPicture.asset(
                          '/icons/Product.svg',
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                          width: 20,
                          height: 20,
                        );
                      },
                    ),
                    label: const Text('عرض المشاريع'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 25 : 32,
                        vertical: isMobile ? 15 : 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      scrollToSection(3);
                    },
                    icon: SvgPicture.asset(
                      '/icons/Call.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      width: 20,
                      height: 20,
                    ),
                    label: const Text('تواصل معي'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 25 : 32,
                        vertical: isMobile ? 15 : 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
