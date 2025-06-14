// TODO Implement this library.
// lib/view/submissionhistoryscreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../model/submission.dart';
import '../myconfig.dart';
import 'editsubmissionscreen.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final User user;
  const SubmissionHistoryScreen({super.key, required this.user});

  @override
  State<SubmissionHistoryScreen> createState() =>
      _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  late Future<List<Submission>> _futureSubmissions;

  @override
  void initState() {
    super.initState();
    _futureSubmissions = _fetchSubmissions();
  }

  Future<List<Submission>> _fetchSubmissions() async {
    final res = await http.post(
      Uri.parse("${MyConfig.server}/get_submissions.php"),
      body: {"worker_id": widget.user.id},
    );

    if (res.statusCode != 200) {
      throw Exception("HTTP ${res.statusCode}");
    }
    final data = jsonDecode(res.body) as List;
    return data.map((e) => Submission.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submission History")),
      body: FutureBuilder<List<Submission>>(
        future: _futureSubmissions,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          } else if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text("No submissions yet"));
          }

          final submissions = snap.data!;
          return ListView.builder(
            itemCount: submissions.length,
            itemBuilder: (context, i) {
              final sub = submissions[i];
              return ListTile(
                leading: const Icon(Icons.assignment_turned_in),
                title: Text("Work ID: ${sub.workId}"),
                subtitle: Text(
                  sub.submissionText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(sub.submittedAt),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => EditSubmissionScreen(
                            submissionId: sub.id,
                            currentText: sub.submissionText,
                          ),
                    ),
                  ).then((_) {
                    setState(() {
                      _futureSubmissions = _fetchSubmissions();
                    });
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
