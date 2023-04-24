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

class TestReadyBothScreen extends StatefulWidget {
  static const routeName = '/readyboth';
  final DatabaseHelper db;
  final int uid;
  final String username;
  final String testType;
  final double displacement;
  const TestReadyBothScreen(
      {required this.db,
      required this.uid,
      required this.username,
      required this.testType,
      required this.displacement,
      Key? key})
      : super(key: key);

  @override
  State<TestReadyBothScreen> createState() => _TestReadyBothScreenState();
}

class _TestReadyBothScreenState extends State<TestReadyBothScreen> {
  late double _displacement = widget.displacement;
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
            uid: widget.uid,
            username: widget.username,
            testType: widget.testType,
            displacement: _displacement,
            leg: 'both'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Balance Test"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Balance on both feet:',
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
                    '• Step 2: Balance on both feet as shown below',
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
                  'assets/both.png',
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
