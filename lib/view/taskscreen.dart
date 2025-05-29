import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../model/task.dart';
import '../myconfig.dart';

class TaskScreen extends StatefulWidget {
  final User user;
  const TaskScreen({super.key, required this.user});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _taskList = [];
  Task? _selectedTask;
  final TextEditingController _submissionController = TextEditingController();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    print("loadTasks() started — worker ID: ${widget.user.id}");

    try {
      final response = await http.post(
        Uri.parse("${MyConfig.server}/get_works.php"),
        body: {"worker_id": (widget.user.id ?? 0).toString()},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsondata = jsonDecode(response.body);

        if (jsondata is List) {
          setState(() {
            _taskList = jsondata.map((json) => Task.fromJson(json)).toList();
          });
          print("Loaded ${_taskList.length} tasks.");
        } else {
          print("JSON is not a list: $jsondata");
        }
      } else {
        print("Server returned status ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  void submitWork(Task task) async {
    String submissionText = _submissionController.text.trim();
    if (submissionText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your work details.")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final response = await http.post(
      Uri.parse("${MyConfig.server}/submit_work.php"),
      body: {
        "work_id": task.id,
        "worker_id": (widget.user.id ?? 0).toString(),
        "submission_text": submissionText,
      },
    );

    if (response.body.trim() == "success") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Submission successful!")));
      setState(() {
        _submissionController.clear();
        _selectedTask = null;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Submission failed.")));
    }

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Tasks")),
      body:
          _taskList.isEmpty
              ? const Center(child: Text("No tasks assigned."))
              : ListView.builder(
                itemCount: _taskList.length,
                itemBuilder: (context, index) {
                  final task = _taskList[index];
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Due: ${task.dueDate}"),
                              Text("Status: ${task.status}"),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _selectedTask = task;
                              _submissionController.clear();
                            });
                          },
                        ),
                        if (_selectedTask == task)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "What did you complete?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _submissionController,
                                  maxLines: 5,
                                  enabled:
                                      task.status != "pending confirmation",
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText:
                                        task.status == "pending confirmation"
                                            ? "Submission locked — waiting for confirmation."
                                            : "Enter details...",
                                    filled: true,
                                    fillColor:
                                        task.status == "pending confirmation"
                                            ? Colors.grey[300]
                                            : Colors.yellow[50],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed:
                                      isSubmitting ||
                                              task.status ==
                                                  "pending confirmation"
                                          ? null
                                          : () => submitWork(task),
                                  icon: const Icon(Icons.upload_file),
                                  label: Text(
                                    isSubmitting
                                        ? "Submitting..."
                                        : "Submit Work",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber[700],
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                if (task.status == "pending confirmation")
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      "Your submission is pending confirmation by supervisor.",
                                      style: TextStyle(color: Colors.red[600]),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
