import 'package:flutter/material.dart';
import '../services/database/database.dart';
import '../classes/test.dart';
import 'dart:async';
import 'dart:math';

class HistoryTestList extends StatefulWidget {
  final DatabaseHelper db;
  final int uid;

  HistoryTestList({
    required this.db,
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  _HistoryTestListState createState() => _HistoryTestListState();
}

class _HistoryTestListState extends State<HistoryTestList> {
  List<Test>? tests = [];

  @override
  void initState() {
    super.initState();
    getTests();
    // perform any initialization here
  }

  void getTests() async {
    List<Test>? newTests = await widget.db.getTestsByOwnerId(widget.uid);
    setState(() {
      tests = newTests;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: (tests?.length ?? 0),
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic>? map = tests?[index].toMap();
            String ret = "";
            if (map != null) {
              ret = "(" +
                  map["id"].toString() +
                  ") | " +
                  map["name"] +
                  " | Score: " +
                  map["score"].toString();
            }
            return ListTile(
              title: Text(ret),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Test newTest = Test();
            newTest.name = "Generated Test by UID " + widget.uid.toString();
            newTest.oId = widget.uid;
            newTest.date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
            Random rn = Random(newTest.date);
            newTest.score = rn.nextInt(101);
            int id = await widget.db.saveTest(newTest);
            getTests();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
