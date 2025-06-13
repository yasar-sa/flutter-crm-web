class ProjectAnalytics {
  final ProjectData data;
  final List<dynamic> plots;

  ProjectAnalytics({required this.data, required this.plots});

  factory ProjectAnalytics.fromJson(Map<String, dynamic> json) {
    return ProjectAnalytics(
      data: ProjectData.fromJson(json['data']),
      plots: json['plots'] ?? [],
    );
  }
}

class ProjectData {
  final String projectName;
  final String location;
  final String area;
  final String dtpcNumber;
  final String localBodyApproval;
  final String rercAppNo;

  ProjectData({
    required this.projectName,
    required this.location,
    required this.area,
    required this.dtpcNumber,
    required this.localBodyApproval,
    required this.rercAppNo,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    return ProjectData(
      projectName: json['projectName'] ?? '',
      location: json['location'] ?? '',
      area: json['area'] ?? '',
      dtpcNumber: json['dtpcNumber'] ?? '',
      localBodyApproval: json['localBodyApproval'] ?? '',
      rercAppNo: json['rercAppNo'] ?? '',
    );
  }
}
