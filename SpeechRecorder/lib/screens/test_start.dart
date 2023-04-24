import 'package:flutter/material.dart';
import 'package:record_with_play/screens/test_ready_left.dart';

import '../services/database/database.dart';

class TestStartScreen extends StatefulWidget {
  static const routeName = '/test';
  final DatabaseHelper db;
  final int uid;
  final String username;

  const TestStartScreen({
    required this.db,
    required this.uid,
    required this.username,
    Key? key,
  }) : super(key: key);

  @override
  State<TestStartScreen> createState() => _TestStartScreenState();
}

class _TestStartScreenState extends State<TestStartScreen> {
  void baselineTest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestReadyLeftScreen(
          db: widget.db,
          uid: widget.uid,
          username: widget.username,
          testType: 'Baseline',
        ),
      ),
    );
  }

  void diagnosticTest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestReadyLeftScreen(
          db: widget.db,
          uid: widget.uid,
          username: widget.username,
          testType: 'Diagnostic',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Test'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16.0),
          const Text(
            'Select a test:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: baselineTest,
                child: const Text('Baseline'),
              ),
              ElevatedButton(
                onPressed: diagnosticTest,
                child: const Text('Diagnostic'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
