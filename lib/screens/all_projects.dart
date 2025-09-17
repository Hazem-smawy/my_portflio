import 'package:flutter/material.dart';
import 'package:my_portflio/data.dart';
import 'package:my_portflio/widgets/project_card.dart';

class AllProjects extends StatelessWidget {
  const AllProjects({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'المشاريع المميزة',
            style: TextStyle(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jazeera',
            ),
          ),
          SizedBox(height: isMobile ? 0 : 30),
          if (isMobile)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ProjectCard(project: projects[index]),
                );
              },
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projects.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 450,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                return ProjectCard(project: projects[index]);
              },
            ),
        ],
      ),
    );
  }
}
