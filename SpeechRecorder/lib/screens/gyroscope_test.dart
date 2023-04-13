import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:record_with_play/screens/test_ready_right.dart';
import 'package:record_with_play/screens/test_score.dart';
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
  final String testType;
  final double displacement;
  final String leg;
  const GyroScopeScreen(
      {required this.db,
      required this.uid,
      required this.username,
      required this.testType,
      required this.displacement,
      required this.leg,
      Key? key})
      : super(key: key);

  @override
  State<GyroScopeScreen> createState() => _GyroScopeScreenState();
}

class _GyroScopeScreenState extends State<GyroScopeScreen> {
  double x = 0, y = 0, z = 0;
  late double _displacement = widget.displacement;
  Timer? timer;
  int count = 0;
  double initx = 0, inity = 0, initz = 0;
  List<GyroscopeEvent> _gyroscopeEvents = [];
  bool _isRecording = false;
  int _countdown = 5;
  late Timer _timer;
  late AudioPlayer player;
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
    player = AudioPlayer();
    super.initState();
    _startRecording();
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

  Future<void> _startRecording() async {
    var file = File('countdown.mp3');
    bool exists = await file.exists();
    if (exists) {
      print('File exists!');
    } else {
      print('File not found!');
    }
    await player.play('countdown.mp3', isLocal: true);
    setState(() {
      _isRecording = true;
      _countdown = 5;
      _gyroscopeEvents.clear();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown == 0) {
        _timer.cancel();
        _stopRecording();
      }
      gyroscopeEvents.listen((GyroscopeEvent event) {
        if (_isRecording) {
          setState(() {
            _gyroscopeEvents.add(event);
          });
        }
      });
    });
    _calculateDisplacement();
  }

  void _stopRecording() {
    _isRecording = false;
    sendResultsToDatabase(_displacement);
    if (widget.leg == 'right') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestResultScreen(score: _displacement),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestReadyRightScreen(
              db: widget.db,
              uid: widget.uid,
              username: widget.username,
              testType: widget.testType,
              displacement: _displacement),
        ),
      );
    }
  }

  void _calculateDisplacement() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      initx = _gyroscopeEvents[0].x;
      inity = _gyroscopeEvents[0].y;
      initz = _gyroscopeEvents[0].z;
      for (var i = 1; i < _gyroscopeEvents.length; i++) {
        _displacement = _displacement +
            sqrt(pow(_gyroscopeEvents[i].x - initx, 2) +
                    pow(_gyroscopeEvents[i].y - inity, 2) +
                    pow(_gyroscopeEvents[i].z - initz, 2))
                .round();
      }
    });
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
            const Text(
              'Hold for 5 seconds:',
              style: TextStyle(fontSize: 40),
            ),
            Text(
              '$_countdown',
              style: const TextStyle(fontSize: 55),
            ),
          ],
        ),
      ),
    );
  }
}
