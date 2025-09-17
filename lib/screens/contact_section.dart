import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_portflio/controller/theme_controller.dart';
import 'package:svg_flutter/svg.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Column(
      children: [
        // Glass Container
        Container(
          padding: const EdgeInsets.all(30),
          // margin: const EdgeInsets.symmetric(horizontal: 20),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(0),
          //   gradient: LinearGradient(
          //     colors: [
          //       themeController.currentColor.value.withAlpha(100),
          //       themeController.isDark.value
          //           ? Colors.black.withAlpha(100)
          //           : Colors.white.withAlpha(100),
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   "دعنا نعمل معًا!",
              //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //     fontWeight: FontWeight.w600,
              //     color: themeController.isDark.value
              //         ? Colors.white
              //         : Colors.black87,
              //   ),
              // ),
              const SizedBox(height: 20),

              const SizedBox(height: 50),
              Text(
                'تواصل معي',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 36),
              // Contact Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ContactButton(
                    assetPath: 'assets/icons/twitter.svg',
                    label: 'Email',
                    onTap: () => _launchUrl('mailto:your.email@example.com'),
                  ),
                  ContactButton(
                    assetPath: 'assets/icons/Call.svg',
                    label: 'Email',
                    onTap: () => _launchUrl('mailto:your.email@example.com'),
                  ),
                  ContactButton(
                    assetPath: 'assets/icons/Facebook.svg',
                    label: 'GitHub',
                    onTap: () => _launchUrl('https://github.com'),
                  ),
                  ContactButton(
                    assetPath: 'assets/icons/Linkedin.svg',
                    label: 'LinkedIn',
                    onTap: () => _launchUrl('https://linkedin.com'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'hazemsmawy@gmail.com',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'Roboto'),
              ),
              SizedBox(height: 12),
              Text(
                '+967775426836',
                textDirection: TextDirection.ltr,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'Roboto'),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }

  void _launchUrl(String url) {
    // TODO: implement launch logic with url_launcher
  }
}

class ContactButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const ContactButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            width: 32,
            height: 32,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
