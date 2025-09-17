import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_portflio/models/project_model.dart';

class ProjectDetailsPage extends StatefulWidget {
  final ProjectModel project;
  const ProjectDetailsPage({super.key, required this.project});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentBackgroundIndex = 0;

  @override
  void initState() {
    super.initState();

    // Scroll listener to update background
    _scrollController.addListener(() {
      if (_scrollController.hasClients && widget.project.gallary.length > 1) {
        double offset = _scrollController.offset;
        double itemHeight = 320; // card height + spacing
        int index = (offset / itemHeight).round();
        if (index >= widget.project.gallary.length - 1) {
          index = widget.project.gallary.length - 2;
        }
        if (_currentBackgroundIndex != index) {
          setState(() {
            _currentBackgroundIndex = index;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 🔹 Dynamic blurred background
            if (widget.project.gallary.isNotEmpty)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: widget.project.gallary[_currentBackgroundIndex + 1],
                  fit: BoxFit.cover,
                  // Show a colored placeholder while loading
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade900, // or any color you prefer
                  ),
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.grey.shade800),
                ),
              ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),

            // 🔹 Scrollable content with SliverAppBar
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  expandedHeight: 250,
                  pinned: true,
                  floating: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ClipPath(
                      clipper: CurvedImageClipper(),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Project image
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.project.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Overlay color (customize color and opacity as needed)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                0.4,
                              ), // Change color/opacity here
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    widget.project.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  centerTitle: true,
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.project.description,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                if (widget.project.gallary.length > 1)
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 50,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final imageUrl = widget.project.gallary[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassBehindCard(imageUrl: imageUrl),
                        );
                      }, childCount: widget.project.gallary.length),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Glass behind image card
class GlassBehindCard extends StatelessWidget {
  final String imageUrl;
  const GlassBehindCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🔹 Glass behind image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
            ),
          ),
        ),
        // 🔹 Actual image above
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

/// 🔹 Curved clipper for top image
class CurvedImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 50,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
