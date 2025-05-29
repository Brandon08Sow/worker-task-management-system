class Task {
  String id;
  String title;
  String description;
  String assignedTo;
  String dateAssigned;
  String dueDate;
  String status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.dateAssigned,
    required this.dueDate,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      assignedTo: json['assigned_to'].toString(),
      dateAssigned: json['date_assigned'].toString(),
      dueDate: json['due_date'].toString(),
      status: json['status'].toString(),
    );
  }
}
