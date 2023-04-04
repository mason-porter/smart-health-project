import 'package:flutter/material.dart';
import 'scatterplot_chart.dart';

class OverviewWidget extends StatelessWidget {
  final String username;
  final VoidCallback logout;

  const OverviewWidget({
    Key? key,
    required this.username,
    required this.logout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 8.0),
              child: Text('This is $username\'s overview page.'),
            ),
            const ScatterPlot(
              data: [
                [1.0, 2.0],
                [3.0, 4.0],
                [5.0, 6.0],
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: logout,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
