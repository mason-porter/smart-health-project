import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:record_with_play/classes/test.dart';
import 'package:record_with_play/services/database/database.dart';

class ScatterPlot extends StatefulWidget {
  final DatabaseHelper db;

  const ScatterPlot({Key? key, required this.db}) : super(key: key);

  @override
  _ScatterPlotState createState() => _ScatterPlotState();
}

class _ScatterPlotState extends State<ScatterPlot> {
  List<List<num>> data = [];

  @override
  void initState() {
    super.initState();
    getTestsData();
  }

  void getTestsData() async {
    List<List<num>> newData = [];
    List<Test> tests = await widget.db.getTests();
    for (Test test in tests) {
      newData.add([test.oId ?? -1, test.score ?? 0]);
    }
    setState(() {
      data = newData;
    });
    debugPrint(data.toString());
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
                  type: 'scatter',
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
        const Text('User ID')
      ],
    ));
  }
}
