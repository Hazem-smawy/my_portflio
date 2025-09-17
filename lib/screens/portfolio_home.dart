import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:my_portflio/controller/theme_controller.dart';
import 'package:my_portflio/screens/contact_section.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_shapes.dart';
import '../widgets/project_card.dart';
import '../widgets/skill_chip.dart';
import '../models/project_model.dart';

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
                          _buildHeroSection(),
                          _buildAboutSection(),
                          _buildSkillsSection(),
                          _buildProjectsSection(),
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
                spacing: 12,
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

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0.9),
      elevation: 0,
      title: Text(
        'Portfolio',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () {
            // Theme toggle would go here
          },
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

  Widget _buildHeroSection() {
    final imageUrl =
        'https://i.pinimg.com/1200x/62/9a/c0/629ac0aaca3122259a4d9592e8bfd7c0.jpg';

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile avatar with custom shape
              Container(
                width: 150,
                height: 150,
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
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                // put this where you had the Icon
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
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
              const SizedBox(height: 30),

              // Name and title
              Text(
                'حازم السماوي',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jazeera',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'أصنع تطبيقات مميزة تجمع بين الإبداع والتقنية.\nأؤمن أن التفاصيل تصنع الفرق.',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Jannat',
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // CTA Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _scrollToSection(1);
                    },
                    // icon: SvgPicture.asset(
                    //   'assets/icons/Product.svg',
                    //   colorFilter: ColorFilter.mode(
                    //     Theme.of(context)
                    //         .colorScheme
                    //         .secondary, // same as button text/icon color
                    //     BlendMode.srcIn,
                    //   ),
                    //   width: 20,
                    //   height: 20,
                    // ),
                    icon: Builder(
                      builder: (context) {
                        final color = Theme.of(context).colorScheme.primary;

                        return SvgPicture.asset(
                          'assets/icons/Product.svg',
                          colorFilter: ColorFilter.mode(
                            color ?? Colors.white,
                            BlendMode.srcIn,
                          ),
                          width: 20,
                          height: 20,
                        );
                      },
                    ),
                    label: const Text('عرض المشاريع'),
                    style: ElevatedButton.styleFrom(
                      // elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      _scrollToSection(3);
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/Call.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(
                          context,
                        ).colorScheme.primary, // same as button text/icon color
                        BlendMode.srcIn,
                      ),
                      width: 20,
                      height: 20,
                    ),
                    label: const Text('تواصل معي'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
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

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'نبذة عني',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jazeera',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'أنا مطور Flutter شغوف لدي خبرة في إنشاء تطبيقات موبايل جميلة وعالية الأداء. أحب العمل مع الحركات المخصصة وتصميم واجهات المستخدم المعقدة وتقديم تجارب استخدام استثنائية.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                fontFamily: 'Jannat',
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    final skills = [
      'Flutter',
      'Dart',
      'State Management',

      'REST APIs',
      'Firebase',
      'Custom Animations',
      'UI/UX Design',
      'Testing',
      'Agile Development',
      'Git',
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'المهارات',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jazeera',
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: skills.map((skill) => SkillChip(skill: skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection() {
    final projects = [
      ProjectModel(
        title: 'متجر إلكتروني',
        description:
            'تطبيق تجارة إلكترونية متكامل مع حركات مخصصة وواجهة مستخدم جميلة',
        technologies: ['فلاتر', 'فايربيس', 'سترايب'],
        imageUrl:
            'https://i.pinimg.com/1200x/13/5d/64/135d6403099ffe75ae1cda07f83c155e.jpg',
        githubUrl: 'https://github.com',
        liveUrl: '',
        gallary: [
          'https://i.pinimg.com/1200x/8e/f5/12/8ef512dba8432575d534d874006302c0.jpg',
          'https://i.pinimg.com/1200x/72/2e/21/722e2111493036fa7af36b4eff66a066.jpg',
          'https://i.pinimg.com/736x/05/54/16/0554168389c20f49291ed452dfbd8fff.jpg',
          'https://i.pinimg.com/1200x/87/cf/36/87cf36f07e4aee64e836f9d8945f871f.jpg',
          'https://i.pinimg.com/736x/9f/79/24/9f79244d885171d3921dbda1f09bb83a.jpg',
        ],
      ),
      ProjectModel(
        title: 'تطبيق الطقس',
        description: 'تطبيق طقس جميل مع أشكال مخصصة وحركات سلسة',
        technologies: ['فلاتر', 'واجهة برمجة التطبيقات', 'Custom Paint'],
        imageUrl:
            'https://i.pinimg.com/736x/2c/ae/3a/2cae3a9b5683c67de62357aa8e57c92b.jpg',
        githubUrl: 'https://github.com',
        liveUrl: '',
        gallary: [
          'https://i.pinimg.com/736x/05/54/16/0554168389c20f49291ed452dfbd8fff.jpg',
          'https://i.pinimg.com/1200x/59/64/53/596453522aa7931aabcb935ec2e3d740.jpg',
          'https://i.pinimg.com/1200x/ee/cc/71/eecc71ec5e2a66e7065fa77dd0a495d0.jpg',
          'https://i.pinimg.com/1200x/87/cf/36/87cf36f07e4aee64e836f9d8945f871f.jpg',
          'https://i.pinimg.com/736x/57/22/18/57221888a7e3bef11a3c39f883fc0b49.jpg',
        ],
      ),
      ProjectModel(
        title: 'مدير المهام',
        description: 'تطبيق إنتاجية مع إمكانية السحب والإفلات وودجات مخصصة',
        technologies: ['فلاتر', 'SQLite', 'Provider'],
        imageUrl:
            'https://i.pinimg.com/1200x/87/cf/36/87cf36f07e4aee64e836f9d8945f871f.jpg',
        githubUrl: 'https://github.com',
        liveUrl: '',
        gallary: [
          'https://i.pinimg.com/1200x/13/5d/64/135d6403099ffe75ae1cda07f83c155e.jpg',
          'https://i.pinimg.com/1200x/09/c5/56/09c556a566b7885c7fd393ac76eb168c.jpg',
          'https://i.pinimg.com/1200x/b9/0c/85/b90c858bd737a87ab8d2d14c1d1d8633.jpg',
          'https://i.pinimg.com/736x/57/22/18/57221888a7e3bef11a3c39f883fc0b49.jpg',
        ],
      ),
      ProjectModel(
        title: 'تصميم واجهات',
        description: 'تطبيق إنتاجية مع إمكانية السحب والإفلات وودجات مخصصة',
        technologies: ['فلاتر', 'SQLite', 'Provider'],
        imageUrl:
            'https://i.pinimg.com/1200x/8c/4e/5b/8c4e5b978d5e7d8bb5084ae012591475.jpg',
        githubUrl: 'https://github.com',
        liveUrl: '',
        gallary: [
          'https://i.pinimg.com/736x/97/62/0b/97620b56acf5b91e017c32461550a1bd.jpg',
          'https://i.pinimg.com/1200x/2f/df/4f/2fdf4f81861957b69da24a923e73a3b3.jpg',
          'https://i.pinimg.com/736x/c8/e7/c5/c8e7c5ae59ad4ac09ea1842d7829336f.jpg',
          'https://i.pinimg.com/736x/57/22/18/57221888a7e3bef11a3c39f883fc0b49.jpg',
        ],
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'المشاريع المميزة',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jazeera',
            ),
          ),
          const SizedBox(height: 20),
          ...projects.map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProjectCard(project: project),
            ),
          ),
        ],
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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}
