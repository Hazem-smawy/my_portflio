import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:my_portflio/controller/theme_controller.dart';
import 'package:my_portflio/data.dart';
import 'package:my_portflio/screens/about_section.dart';
import 'package:my_portflio/screens/all_projects.dart';
import 'package:my_portflio/screens/contact_section.dart';
import 'package:my_portflio/screens/hearo_secion.dart' show HeroSection;
import 'package:my_portflio/screens/skills_section.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_shapes.dart';
import '../widgets/project_card.dart';
import '../widgets/skill_chip.dart';

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;
  final ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    _scrollController.addListener(() {
      setState(() {
        _showBackToTop = _scrollController.offset > 300;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _colorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Background with custom shapes
            const CustomBackground(),

            // Main content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // _buildAppBar(),
                SliverToBoxAdapter(
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 375),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: [
                          HeroSection(
                            fadeAnimation: _fadeAnimation,
                            slideAnimation: _slideAnimation,
                            scrollToSection: (section) {
                              _scrollToSection(section);
                            },
                          ),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height * 0.1,
                          // ),
                          SizedBox(
                            height: 200,
                            // If using a PNG fallback, you would use this instead:
                            // child: Image.asset('assets/images/Shot.png'),
                            child: SvgPicture.asset(
                              'assets/images/Shot.svg',
                            ), // Keep using SVG if you clean the file
                          ),
                          AboutSection(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),

                          SkillsSection(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),

                          AllProjects(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),

                          ContactSection(),
                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 8,
              right: 20,
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => IconButton.filledTonal(
                      icon: Icon(
                        themeController.isDark.value
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                      onPressed: () => themeController.toggleTheme(),
                    ),
                  ),

                  _buildShowColors(),
                ],
              ),
            ),
            // Back to top button
            if (_showBackToTop)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  mini: true,
                  elevation: 0,
                  shape: CircleBorder(),
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _showColors = false;
  Timer? _colorTimer;
  final Duration _colorAnimDuration = const Duration(milliseconds: 350);

  void _startColorTimer() {
    _colorTimer?.cancel();
    _colorTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _showColors) {
        setState(() {
          _showColors = false;
        });
      }
    });
  }

  Widget _buildShowColors() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Always show the palette icon
        IconButton.filledTonal(
          icon: const Icon(Icons.palette_outlined),
          onPressed: () {
            setState(() {
              _showColors = !_showColors;
              if (_showColors) {
                _startColorTimer();
              } else {
                _colorTimer?.cancel();
              }
            });
          },
        ),
        AnimatedSwitcher(
          duration: _colorAnimDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final offsetTween = Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            );
            return SlideTransition(
              position: offsetTween.animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _showColors
              ? Column(
                  key: const ValueKey('colors'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    _colorButton(themeController, Colors.deepPurple),
                    const SizedBox(height: 8),
                    _colorButton(themeController, Colors.indigo),
                    const SizedBox(height: 8),
                    _colorButton(themeController, Colors.red),
                    const SizedBox(height: 8),
                    _colorButton(themeController, Colors.cyan),
                    const SizedBox(height: 8),
                    _colorButton(themeController, Colors.amber),
                    const SizedBox(height: 8),
                    _colorButton(themeController, Colors.green),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }

  Widget _colorButton(ThemeController controller, MaterialColor color) {
    return GestureDetector(
      onTap: () => controller.setColor(color),
      child: Obx(
        () => Opacity(
          opacity: controller.currentColor.value == color ? 0.9 : 0.5,
          child: CircleAvatar(
            radius: controller.currentColor.value == color ? 17 : 15,
            backgroundColor: controller.currentColor.value == color
                ? Theme.of(context).colorScheme.primary
                : null,
            child: CircleAvatar(
              backgroundColor: color,
              radius: 15,

              child: controller.currentColor.value == color
                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToSection(int section) {
    double offset = 0;
    switch (section) {
      case 1: // Projects
        offset = MediaQuery.of(context).size.height * 1.5;
        break;
      case 2: // Skills
        offset = MediaQuery.of(context).size.height * 1.2;
        break;
      case 3: // Contact
        offset = MediaQuery.of(context).size.height * 3.2;
        break;
    }

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
}
