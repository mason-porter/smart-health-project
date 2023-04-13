import 'package:flutter/material.dart';
import 'package:record_with_play/screens/history_test_list.dart';
import 'package:record_with_play/screens/overview.dart';
import '../services/database/database.dart';
import 'gyroscope_test.dart';

typedef void VoidCallback();

class MainTabMenu extends StatelessWidget {
  static const routeName = '/main';
  final DatabaseHelper db;
  final String uname;
  final bool admin;
  final int uid;
  final VoidCallback logout;
  const MainTabMenu(
      {required this.db,
      required this.uid,
      required this.uname,
      required this.admin,
      required this.logout,
      Key? key})
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
          ),
          body: TabBarView(
            children: [
              HistoryTestList(db: db, uid: uid),
              OverviewWidget(
                  db: db, username: uname, admin: admin, logout: logout),
              GyroScopeScreen(db: db, uid: uid, username: uname),
            ],
          ),
        ),
      ),
    );
  }
}
