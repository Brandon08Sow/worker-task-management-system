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
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assignedTo: json['assigned_to'],
      dateAssigned: json['date_assigned'],
      dueDate: json['due_date'],
      status: json['status'],
    );
  }
}
