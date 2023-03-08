import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GyroScopeScreen extends StatefulWidget {
  static const routeName = '/gyro';
  const GyroScopeScreen({Key? key}) : super(key: key);

  @override
  State<GyroScopeScreen> createState() => _GyroScopeScreenState();
}

class _GyroScopeScreenState extends State<GyroScopeScreen> {
  double x = 0, y = 0, z = 0;
  double displacement = 0;
  Timer? timer;
  int count = 0;
  double initx = 0, inity = 0, initz = 0;
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
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      gyroscopeEvents.listen((GyroscopeEvent event) {
        if (count == 0) {
          initx = event.x;
          inity = event.y;
          initz = event.z;
        }
        count = count + 1;
        displacement = displacement +
            sqrt(pow(event.x - initx, 2) +
                pow(event.y - inity, 2) +
                pow(event.z - initz, 2));
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Balance Test"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            Text(
              displacement.toString(),
              style: const TextStyle(fontSize: 30),
            )
          ])),
    );
  }
}
