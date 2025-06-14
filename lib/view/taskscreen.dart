import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../model/task.dart';
import '../myconfig.dart';
import 'submitworkscreen.dart';

class TaskScreen extends StatefulWidget {
  final User user;
  const TaskScreen({super.key, required this.user});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _taskList = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final response = await http.post(
        Uri.parse("${MyConfig.server}/get_works.php"),
        body: {"worker_id": widget.user.id},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsondata = jsonDecode(response.body);

        setState(() {
          _taskList = jsondata.map((json) => Task.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        backgroundColor: Colors.amber[700],
      ),
      body:
          _taskList.isEmpty
              ? const Center(child: Text("No tasks assigned."))
              : ListView.builder(
                itemCount: _taskList.length,
                itemBuilder: (context, index) {
                  final task = _taskList[index];
                  return Card(
                    child: ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Due: ${task.dueDate}"),
                          Text("Status: ${task.status}"),
                        ],
                      ),
                      onTap:
                          task.status == "pending confirmation"
                              ? null
                              : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => SubmitWorkScreen(
                                          task: task,
                                          user: widget.user,
                                        ),
                                  ),
                                ).then((result) {
                                  if (result == true) {
                                    loadTasks();
                                  }
                                });
                              },
                    ),
                  );
                },
              ),
    );
  }
}
