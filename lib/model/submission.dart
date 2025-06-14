// lib/model/submission.dart
class Submission {
  final String id;
  final String workId;
  final String submissionText;
  final String submittedAt;
  final String? taskTitle;

  Submission({
    required this.id,
    required this.workId,
    required this.submissionText,
    required this.submittedAt,
    this.taskTitle,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'].toString(),
      workId: json['work_id'].toString(),
      submissionText: json['submission_text'] ?? '',
      submittedAt: json['submitted_at'] ?? '',
      taskTitle: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'work_id': workId,
      'submission_text': submissionText,
      'submitted_at': submittedAt,
      'title': taskTitle,
    };
  }
}
