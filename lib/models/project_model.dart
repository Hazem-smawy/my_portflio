class ProjectModel {
  final int id;
  final String title;
  final String description;
  final List<String> technologies;
  final String imageUrl;
  final String githubUrl;
  final String liveUrl;
  final List<String> gallary;

  ProjectModel({
    required this.id,
    required this.gallary,
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageUrl,
    required this.githubUrl,
    required this.liveUrl,
  });
}
