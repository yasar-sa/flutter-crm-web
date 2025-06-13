class Lead {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String creditScore;
  final String project;
  final List<Project> projects;

  Lead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.creditScore,
    required this.project,
    required this.projects,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    var projectsData = json['projects'] as List?;
    List<Project> projects =
        projectsData?.map((proj) => Project.fromJson(proj)).toList() ?? [];

    return Lead(
      id: json['id'],
      name: json['data']['name'],
      email: json['data']['email'],
      phone: json['data']['phone'],
      creditScore: json['data']['creditScore'],
      project: json['data']['project'],
      projects: projects,
    );
  }
}

class Project {
  final String projectName;

  Project({required this.projectName});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(projectName: json['projectName']);
  }
}
