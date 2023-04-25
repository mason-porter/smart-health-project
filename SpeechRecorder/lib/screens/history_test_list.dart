import 'package:flutter/material.dart';
import '../services/database/database.dart';
import '../classes/test.dart';
import '../classes/user.dart';
import 'dart:async';
import 'dart:math';
import './test_view.dart';

class HistoryTestList extends StatefulWidget {
  final DatabaseHelper db;
  final bool isAdmin;
  final int uid;

  HistoryTestList({
    required this.db,
    required this.uid,
    required this.isAdmin,
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
    List<Test>? newTests;
    if (widget.isAdmin == false) {
      newTests = await widget.db.getTestsByOwnerId(widget.uid);
    } else {
      newTests = await widget.db.getTests();
    }
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
            Test? test = tests?[index];
            Map<String, dynamic>? map = tests?[index].toMap();
            String ret = "";
            if (map != null) {
              ret = "(" +
                  map["id"].toString() +
                  ") | " +
                  map["name"] +
                  " | Score: " +
                  map["score_final"].toString();
            }
            return ListTile(
                title: Text(ret),
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestView(
                                db: widget.db,
                                test: test,
                                refreshCallback: () => {getTests()}),
                          )),
                    });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Test newTest = Test();
            newTest.name = "Generated Test by UID " + widget.uid.toString();
            newTest.oId = widget.uid;
            newTest.date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
            Random rn = Random(newTest.date);
            int nl = rn.nextInt(101);
            int nr = rn.nextInt(101);
            int nb = rn.nextInt(101);
            newTest.scoreL = nl;
            newTest.scoreR = nr;
            newTest.scoreB = nb;
            newTest.scoreS = (nl + nr) ~/ 2;
            newTest.scoreFinal = ((nl + nr) + (nb * 2)) ~/ 4;
            int id = await widget.db.saveTest(newTest);
            getTests();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
