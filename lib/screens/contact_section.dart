import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_portflio/controller/theme_controller.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'تواصل معي',
            style: TextStyle(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jazeera',
            ),
          ),
          SizedBox(height: isMobile ? 24 : 36),
          // Contact Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContactButton(
                assetPath: 'assets/icons/twitter.svg',
                label: 'Twitter',
                onTap: () => _launchUrl('https://twitter.com/your_handle'),
              ),
              SizedBox(width: isMobile ? 16 : 24),
              ContactButton(
                assetPath: 'assets/icons/Call.svg',
                label: 'Email',
                onTap: () => _launchUrl('mailto:hazemsmawy@gmail.com'),
              ),
              SizedBox(width: isMobile ? 16 : 24),
              ContactButton(
                assetPath: 'assets/icons/Facebook.svg',
                label: 'GitHub',
                onTap: () => _launchUrl('https://github.com/your_username'),
              ),
              SizedBox(width: isMobile ? 16 : 24),
              ContactButton(
                assetPath: 'assets/icons/Linkedin.svg',
                label: 'LinkedIn',
                onTap: () => _launchUrl('https://linkedin.com/in/your_profile'),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 24 : 36),
          SelectableText(
            'hazemsmawy@gmail.com',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontFamily: 'Roboto'),
          ),
          const SizedBox(height: 12),
          SelectableText(
            '+967 775 426 836',
            textDirection: TextDirection.ltr,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) {
    launchUrl(Uri.parse(url));
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
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}
