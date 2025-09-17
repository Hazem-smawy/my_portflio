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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

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

            if (isMobile)
              _buildNarrowLayout(context)
            else
              _buildWideLayout(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverAppBar(context, isMobile: true),
        _buildProjectInfo(context, isMobile: true),
        _buildGallery(context, isMobile: true),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Column(
      children: [
        _buildAppBarForWide(context),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Details
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.project.description,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.6,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right Column: Gallery
              Expanded(
                flex: 3,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [_buildGallery(context, isMobile: false)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBarForWide(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.05),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.project.title,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  SliverAppBar _buildSliverAppBar(
    BuildContext context, {
    required bool isMobile,
  }) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: isMobile ? 250 : 350,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        background: ClipPath(
          clipper: CurvedImageClipper(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.project.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
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
    );
  }

  Widget _buildProjectInfo(BuildContext context, {required bool isMobile}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: isMobile ? 16 : 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.project.title,
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.project.description,
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                height: 1.5,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery(BuildContext context, {required bool isMobile}) {
    if (widget.project.gallary.length <= 1) return const SliverToBoxAdapter();

    if (isMobile) {
      return SliverPadding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassBehindCard(imageUrl: widget.project.gallary[index]),
            ),
            childCount: widget.project.gallary.length,
          ),
        ),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                GlassBehindCard(imageUrl: widget.project.gallary[index]),
            childCount: widget.project.gallary.length,
          ),
        ),
      );
    }
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
