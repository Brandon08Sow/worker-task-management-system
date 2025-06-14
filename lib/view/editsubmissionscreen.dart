import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../myconfig.dart';

class EditSubmissionScreen extends StatefulWidget {
  final String submissionId;
  final String currentText;

  const EditSubmissionScreen({
    super.key,
    required this.submissionId,
    required this.currentText,
  });

  @override
  State<EditSubmissionScreen> createState() => _EditSubmissionScreenState();
}

class _EditSubmissionScreenState extends State<EditSubmissionScreen> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentText);
  }

  Future<void> _submitUpdate() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Submission cannot be empty")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final res = await http.post(
      Uri.parse("${MyConfig.server}/edit_submission.php"),
      body: {
        "submission_id": widget.submissionId,
        "updated_text": _controller.text,
      },
    );

    setState(() => _isSubmitting = false);

    final ok =
        res.statusCode == 200 && jsonDecode(res.body)['status'] == "success";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? "Submission updated successfully"
              : "Failed to update submission.",
        ),
      ),
    );
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Submission"),
        backgroundColor: Colors.amber[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Edit your submission:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter updated submission text",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitUpdate,
                icon:
                    _isSubmitting
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.save),
                label: Text(_isSubmitting ? "Saving..." : "Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
