import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:record_with_play/screens/gyroscope_test.dart';
import 'package:record_with_play/screens/test_score.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database/database.dart';
import '../classes/test.dart';

class TestReadyLeftScreen extends StatefulWidget {
  static const routeName = '/readyleft';
  final DatabaseHelper db;
  Test test;
  final int uid;
  final String username;
  final String testType;

  TestReadyLeftScreen(
      {required this.db,
      required this.test,
      required this.uid,
      required this.username,
      required this.testType,
      Key? key})
      : super(key: key);

  @override
  State<TestReadyLeftScreen> createState() => _TestReadyLeftScreenState();
}

class _TestReadyLeftScreenState extends State<TestReadyLeftScreen> {
  customizeStatusAndNavigationBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
  }

  @override
  void initState() {
    customizeStatusAndNavigationBar();
    super.initState();
  }

  void goToRecord() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GyroScopeScreen(
            db: widget.db,
            test: widget.test,
            uid: widget.uid,
            username: widget.username,
            testType: widget.testType,
            displacement: 0,
            leg: 'left'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Balance Test"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Text(
                'Balance on your left foot:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    '• Step 1: Hold your device in your dominant hand',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    '• Step 2: Balance on your left foot as shown below',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    '• Step 3: Close your eyes immediately after starting the test',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: goToRecord,
              child: const Text('Start Test'),
            ),
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.8,
                child: Image.asset(
                  'assets/left.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
