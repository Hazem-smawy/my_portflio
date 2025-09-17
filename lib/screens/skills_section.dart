import 'package:flutter/material.dart';
import 'package:my_portflio/data.dart';
import 'package:my_portflio/widgets/skill_chip.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 40,
        vertical: isMobile ? 10 : 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'المهارات',
            style: TextStyle(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jazeera',
            ),
          ),
          SizedBox(height: isMobile ? 10 : 20),
          Wrap(
            spacing: isMobile ? 8 : 20,
            runSpacing: isMobile ? 8 : 20,
            alignment: WrapAlignment.center,
            children: skills.map((skill) => SkillChip(skill: skill)).toList(),
          ),
        ],
      ),
    );
  }
}
