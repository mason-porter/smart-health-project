import 'package:flutter/material.dart';

class TestResultScreen extends StatelessWidget {
  final int score;

  const TestResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Test Result'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              ElevatedButton(
                child: const Text('Finish Test'),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              )
            ],
          ),
        ));
  }
}
