import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillChip extends StatefulWidget {
  final String skill;

  const SkillChip({super.key, required this.skill});

  @override
  State<SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<SkillChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    print(widget.skill);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      end: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getSkillIcon(widget.skill),
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.skill,
                    style: TextStyle(
                      fontFamily: 'Jannat',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getSkillIcon(String skill) {
    switch (skill.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash_outlined;
      case 'dart':
        return Icons.code_outlined;
      case 'firebase':
        return Icons.cloud_outlined;
      case 'rest apis':
        return Icons.api_outlined;
      case 'state management':
        return Icons.settings_outlined;
      case 'custom animations':
        return Icons.animation_outlined;
      case 'ui/ux design':
        return Icons.design_services_outlined;
      case 'git':
        return Icons.source_outlined;
      case 'agile development':
        return Icons.speed_outlined;
      case 'testing':
        return Icons.bug_report_outlined;
      default:
        return Icons.star;
    }
  }
}
