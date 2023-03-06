import 'package:flutter/material.dart';
import 'record_widget.dart';
import '../services/database/database.dart';

class MainTabMenu extends StatelessWidget {
  static const routeName = '/main';
  final DatabaseHelper db;
  final String uname;
  const MainTabMenu({required this.db, required this.uname, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Hello, " + uname),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'History', icon: Icon(Icons.history)),
                Tab(text: 'Overview', icon: Icon(Icons.person)),
                Tab(text: 'New Test', icon: Icon(Icons.post_add_rounded)),
              ],
            ),
            // backgroundColor: const Color(0xff2059ff),
          ),
          body: const TabBarView(
            children: [
              RecordWidget(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
