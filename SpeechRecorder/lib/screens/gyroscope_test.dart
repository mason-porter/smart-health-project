import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/database/database.dart';
import '../classes/test.dart';

class GyroScopeScreen extends StatefulWidget {
  static const routeName = '/gyro';
  final DatabaseHelper db;
  final int uid;
  final String username;
  const GyroScopeScreen(
      {required this.db, required this.uid, required this.username, Key? key})
      : super(key: key);

  @override
  State<GyroScopeScreen> createState() => _GyroScopeScreenState();
}

class _GyroScopeScreenState extends State<GyroScopeScreen> {
  double x = 0, y = 0, z = 0;
  double displacement = 0;
  Timer? timer;
  int count = 0;
  double initx = 0, inity = 0, initz = 0;
  List<GyroscopeEvent> _gyroscopeEvents = [];
  bool _isRecording = false;
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

  void sendResultsToDatabase(double disp) async {
    int score = 100 - (sqrt(100) ~/ 1);
    Test newTest = Test();
    DateTime d = DateTime.now();
    newTest.date = d.millisecondsSinceEpoch ~/ 1000;
    newTest.name = "Test by " +
        widget.username +
        " on " +
        DateFormat('MM/dd/yy HH:mm').format(d);
    newTest.oId = widget.uid;
    newTest.score = score;
    int id = await widget.db.saveTest(newTest);
  }

  void _startRecording() {
    _isRecording = true;
    _gyroscopeEvents.clear();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (_isRecording) {
        setState(() {
          _gyroscopeEvents.add(event);
        });
      }
    });
    Future.delayed(const Duration(seconds: 10), () => _stopRecording());
    _calculateDisplacement();
  }

  void _stopRecording() {
    _isRecording = false;
    sendResultsToDatabase(displacement);
  }

  void _calculateDisplacement() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      displacement = 0;
      initx = _gyroscopeEvents[0].x;
      inity = _gyroscopeEvents[0].y;
      initz = _gyroscopeEvents[0].z;
      for (var i = 1; i < _gyroscopeEvents.length; i++) {
        displacement = displacement +
            sqrt(pow(_gyroscopeEvents[i].x - initx, 2) +
                pow(_gyroscopeEvents[i].y - inity, 2) +
                pow(_gyroscopeEvents[i].z - initz, 2));
      }
    });
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
            ElevatedButton(
              onPressed: _startRecording,
              child: const Text('Start Recording'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Score: $displacement',
              style: const TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
