class Task {
  final String id;
  final String description;
  final String owner;
  final String status;
  final List<Comment> comments;

  Task({
    required this.id,
    required this.description,
    required this.owner,
    required this.status,
    required this.comments,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      owner: json['owner']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      comments: (json['comments'] as List? ?? [])
          .map((c) => Comment.fromJson(c))
          .toList(),
    );
  }
}

class Comment {
  final String comment;
  final String commenter;
  final String timestamp;

  Comment({
    required this.comment,
    required this.commenter,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment: json['comment']?.toString() ?? '',
      commenter: json['commenter']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }
}
