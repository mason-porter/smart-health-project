import 'package:flutter/material.dart';

import '../services/database/database.dart';
import 'line_chart.dart';

class TestResultDScreen extends StatelessWidget {
  final int score;
  final DatabaseHelper db;
  final int uid;

  const TestResultDScreen(
      {super.key, required this.score, required this.db, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Test Result'),
        ),
        body: Center(
            child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              const Text(
                'Test complete!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Your score is:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                '$score',
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Past Results:',
                style: TextStyle(fontSize: 18.0),
              ),
              Expanded(
                child: LineChartWidget(
                  db: db,
                  uid: uid,
                ),
              ),
              ElevatedButton(
                child: const Text('Finish Test'),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        )));
  }
}
