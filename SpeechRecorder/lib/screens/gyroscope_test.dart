import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:just_audio/just_audio.dart';
import 'package:record_with_play/screens/test_ready_both.dart';
import 'package:record_with_play/screens/test_ready_right.dart';
import 'package:record_with_play/screens/test_score.dart';
import 'package:intl/intl.dart';
import 'package:record_with_play/screens/test_score_diag.dart';
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

  Test test;

  GyroScopeScreen(
      {required this.db,
      required this.test,
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
    _startRecording();
  }

  int calcScoreFromDisp(double disp) {
    return 100 - (sqrt(disp) ~/ 1);
  }

  void sendResultsToDatabase() async {
    Test newTest = Test();
    DateTime d = DateTime.now();
    newTest.date = d.millisecondsSinceEpoch ~/ 1000;
    newTest.name = "Test by " +
        widget.username +
        " on " +
        DateFormat('MM/dd/yy HH:mm').format(d);
    newTest.oId = widget.uid;
    newTest.scoreL = widget.test.scoreL;
    newTest.scoreR = widget.test.scoreR;
    newTest.scoreS = widget.test.scoreS;
    newTest.scoreB = widget.test.scoreB;
    newTest.scoreFinal = widget.test.scoreFinal;
    int id = await widget.db.saveTest(newTest);
  }

  Future<void> _startRecording() async {
    final player = AudioPlayer();

    setState(() {
      _isRecording = true;
      _countdown = 5;
      _gyroscopeEvents.clear();
    });
    int x;
    for (x = 5; x > 0; x--) {
      await player.setAsset('assets/$x.mp3');
      await player.play();
      await player.playerStateStream.firstWhere(
          (state) => state.processingState == ProcessingState.completed);

      setState(() {
        _countdown--;
      });

      if (_countdown == 0) {
        _stopRecording();
      }
      gyroscopeEvents.listen((GyroscopeEvent event) {
        if (_isRecording) {
          setState(() {
            _gyroscopeEvents.add(event);
          });
        }
      });
    }
    _calculateDisplacement();
  }

  void _stopRecording() {
    _isRecording = false;
    // sendResultsToDatabase(_displacement);
    if (widget.leg == 'both') {
      widget.test.scoreB = calcScoreFromDisp(_displacement);
      widget.test.scoreFinal =
          ((widget.test.scoreS ?? 0) + (widget.test.scoreB ?? 0)) ~/ 2;
      sendResultsToDatabase();
      if (widget.testType == 'Baseline') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TestResultScreen(score: (widget.test.scoreFinal ?? 0)),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestResultDScreen(
              score: (widget.test.scoreFinal ?? 0),
              db: widget.db,
              uid: widget.uid,
            ),
          ),
        );
      }
    } else if (widget.leg == 'left') {
      widget.test.scoreL = calcScoreFromDisp(_displacement);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestReadyRightScreen(
              db: widget.db,
              test: widget.test,
              uid: widget.uid,
              username: widget.username,
              testType: widget.testType,
              displacement: _displacement),
        ),
      );
    } else {
      // widget.leg == right | Test 2
      widget.test.scoreR = calcScoreFromDisp(_displacement);
      widget.test.scoreS =
          ((widget.test.scoreL ?? 0) + (widget.test.scoreR ?? 0)) ~/ 2;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestReadyBothScreen(
              db: widget.db,
              test: widget.test,
              uid: widget.uid,
              username: widget.username,
              testType: widget.testType,
              displacement: _displacement),
        ),
      );
    }
    debugPrint(widget.test.scoreL.toString() +
        " " +
        widget.test.scoreR.toString() +
        " " +
        widget.test.scoreS.toString() +
        " " +
        widget.test.scoreB.toString() +
        " -> " +
        widget.test.scoreFinal.toString());
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
              style: TextStyle(fontSize: 35),
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
