import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:record_with_play/classes/test.dart';
import 'package:record_with_play/services/database/database.dart';

class LineChartWidget extends StatefulWidget {
  final DatabaseHelper db;
  final int uid;

  const LineChartWidget({
    required this.db,
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<List<num>> data = [];

  @override
  void initState() {
    super.initState();
    getTestsData();
  }

  void getTestsData() async {
    List<List<num>> newData = [];
    List<Test>? tests = await widget.db.getTestsByOwnerId(widget.uid);
    //List<Test> tests = await widget.db.getTests();
    for (Test test in tests) {
      newData.add([tests.indexOf(test) + 1, test.score ?? 0]);
    }
    setState(() {
      data = newData;
    });
    debugPrint(data.toString());
    debugPrint(widget.uid.toString());
  }



  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          // color: Colors.grey[200], // for debugging purposes
          width: 400,
          height: 300,
          child: Echarts(
            option: '''
              {
                animation: false,
                grid: {
                  left: '5%',
                  right: '5%',
                  bottom: '8%',
                  top: '50',
                  height: '240',
                  width: '350',
                  containLabel: true,
                },
                xAxis: {},
                yAxis: { name: 'score'},
                series: [{
                  type: 'line',
                  data: ${data.toString()},
                  markPoint: {
                    data: [
                      {type: 'max', name: 'Max'},
                      {type: 'min', name: 'Min'}
                    ]
                  }
                }]
              }
              ''',
          ),
        ),
        const Text('Test #')
      ],
    ));
  }
}