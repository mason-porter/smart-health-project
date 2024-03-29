import 'package:flutter/material.dart';
import 'package:record_with_play/services/database/database.dart';
import 'scatterplot_chart.dart';
import 'line_chart.dart';

class OverviewWidget extends StatelessWidget {
  final DatabaseHelper db;
  final int uid;
  final String username;
  final VoidCallback logout;
  final bool admin;

  const OverviewWidget({
    Key? key,
    required this.db,
    required this.uid,
    required this.username,
    required this.admin,
    required this.logout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 10.0),
            ),
            Expanded(
                child: Scrollbar(
              child: ListView(
                children: [
                  LineChartWidget(
                    db: db,
                    uid: uid,
                  ),
                  Visibility(
                    visible: admin,
                    child: ScatterPlot(
                      db: db,
                    ),
                  ),
                ],
              ),
            )),
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
