import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

class ScatterPlot extends StatelessWidget {
  final List<List<num>> data;

  const ScatterPlot({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Echarts(
        option: '''
        {
        xAxis: {},
        yAxis: {},
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
      width: 300,
      height: 250,
    );
  }
}
